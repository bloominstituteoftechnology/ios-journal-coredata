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

    

    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {

            let uuid = entry.identifier ?? UUID()
            entry.identifier = uuid

            let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "PUT"

            do {
                guard let representation = entry.entryRepresentation else { throw NSError() }

                try CoreDataStack.shared.save()

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
            completion(error)
            }.resume()

    }

    func update(entry: Entry, representation: EntryRepresentation, context: NSManagedObjectContext) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood.rawValue
        entry.identifier = representation.identifier
        entry.timestamp = representation.timestamp
    }

    func fetchSingleEntryFromPersistentStore(forUUID uuid: UUID, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)

        var result: Entry? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with uuid \(uuid): \(error)")
            }
        }
        return result
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
                do {
                    let entryReqresentationDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                    let entryRepresentations = Array(entryReqresentationDict.values)

                    let backGroundThread = CoreDataStack.shared.container.newBackgroundContext()
                    try self.updateTasks(with: entryRepresentations, context: backGroundThread)
                    
                    completion(nil)
                }catch{
                    NSLog("Error decoding entries: \(error)")
                    completion(error)
                    return
            }
            }.resume()
    }

    private func updateTasks(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws {

        var error: Error? = nil
        context.performAndWait {
            for entryRep in representations {
                guard let uuid = UUID(uuidString: "\(entryRep.identifier)") else { continue }

                if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: uuid, context: context) {
                    self.update(entry: entry, representation: entryRep, context: context)
                } else {
                    let _ = Entry(entryRepresentation: entryRep, context: context)
                }
            }
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }


    let baseURL = URL(string: "https://journal-f3899.firebaseio.com/")!

//    var entries: [Entry] {
//        let loadedData = loadFromPersistentStore()
//        return loadedData
//    }


}
