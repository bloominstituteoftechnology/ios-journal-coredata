//
//  EntryController.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    init() {
        fetchEntriesFromServer()
    }

    typealias CompletionHandler = (Error?) -> Void

    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }

    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {

        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood

        saveToPersistentStore()
        put(entry: entry)
    }

    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }


//    func loadFromPersistentStore() -> [Entry] {
//
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(fetchRequest)
//
//        } catch  {
//            NSLog("Error fetching entry: \(error)")
//            return []
//        }
//    }


        func put(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {

            let uuid = entry.identifier ?? UUID()
            entry.identifier = uuid

            let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "PUT"

            do {
                guard let representation = entry.entryRepresentation else { throw NSError() }
                request.httpBody = try JSONEncoder().encode(representation)
            } catch {
                NSLog("Error encoding entry: \(error)")
                completion(error)
                return
            }
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    NSLog("Error PUTting entry to server: \(error)")
                    completion(error)
                    return
                }
                completion(nil)
                }.resume()

        }


    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {

        guard let identifier = entry.identifier else {
            NSLog("Entry identifier is nil")
            completion(NSError())
            return
        }

        let requestURL = baseURL.appendingPathComponent("\(identifier)").appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "Delete"

        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()

    }

    func update(entry: Entry, representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood.rawValue
        entry.identifier = representation.identifier
        entry.timestamp = representation.timestamp
    }

    func fetchSingleEntryFromPersistentStore(forUUID uuid: UUID) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        let moc = CoreDataStack.shared.mainContext
        return (try? moc.fetch(fetchRequest))?.first
    }

    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        // this add .json at the end of .com/

        URLSession.shared.dataTask(with: requestURL) {(data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }

            DispatchQueue.main.async {
                do {
                    let entryReqresentationDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                    let entryRepresentations = Array(entryReqresentationDict.values)

                    for entryRep in entryRepresentations {
                        let uuid = entryRep.identifier

                        if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: uuid){
                           
                            self.update(entry: entry, representation: entryRep)
                        }else {
                            let _ = Entry(entryRepresentation: entryRep)
                        }


                    }
                    // save changes to disk
                    let moc = CoreDataStack.shared.mainContext
                    try moc.save()
                }catch{
                    NSLog("Error decoding entries: \(error)")
                    completion(error)
                    return
                }
            }
            completion(nil)



            }.resume()


    }


    func saveToPersistentStore() {

        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            print("Saved Entry")
        } catch {
            NSLog("Error saving managed object contex: \(error)")
        }

    }
    let baseURL = URL(string: "https://journal-f3899.firebaseio.com/")!

//    var entries: [Entry] {
//        let loadedData = loadFromPersistentStore()
//        return loadedData
//    }


}
