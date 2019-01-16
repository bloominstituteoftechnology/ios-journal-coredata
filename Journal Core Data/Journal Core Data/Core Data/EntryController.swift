//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    init() {
        fetchEntriesFromServer { (_) in }
    }
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    var baseURL = URL(string: "https://ios-journal.firebaseio.com/")
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: CoreData Methods
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        var results = [Entry]()
//        CoreDataStack.shared.mainContext.performAndWait {
//            results = try! fetchRequest.execute()
//        }
//        return results
//        
//    }
    
    
    func createEntry(title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString) {
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        newEntry.title = title
        newEntry.bodyText = bodyText
        newEntry.mood = mood
        newEntry.timestamp = Date()
        newEntry.identifier = identifier
        put(entry: newEntry) { (_) in}
        saveToPersistentStore()
    }
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date.init()
        entry.mood = mood
        entry.identifier = identifier
        put(entry: entry) { (_) in}
        saveToPersistentStore()
    }
    
        //In this application we are checking for identifiers when getting data from the server, so it is necessary to call the server method before the Core Data method in the deleteEntryFromServer method. Else there will be no timestamp because the entry has already been deleted.
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry) { (_) in}
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    //MARK: Networking Methods
    func put(entry: Entry, completionHandler: @ escaping CompletionHandler) {
        let requestURL = baseURL?.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "PUT"
        do {
        request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            print("error encoding 'Entry' object into JSON")
            completionHandler(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error initiaing dataTask")
            }
            completionHandler(error)
        }.resume()
    }

    func deleteEntryFromServer(entry: Entry, completionHandler: @escaping CompletionHandler) {
        let requestURL = baseURL?.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error initiaing dataTask")
            }
            completionHandler(error)
        }.resume()
    }
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        if let timesetamp = entry.timestamp, timesetamp > entryRepresentation.timestamp {
            return
        } else {
            entry.title = entryRepresentation.title
            entry.bodyText = entryRepresentation.bodyText
            entry.mood = entryRepresentation.mood
            entry.timestamp = entryRepresentation.timestamp
        }
    }
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        let moc = CoreDataStack.shared.mainContext
        let matchingEntries = try? moc.fetch(fetchRequest)
        
        //The trailing '?' here says "if matchingTasks is not nil, return first, if it is nil then return nil
        return matchingEntries?.first
    }
    func fetchEntriesFromServer(completionHandler: @escaping CompletionHandler) {
        let requestURL = baseURL?.appendingPathExtension("json")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error initiaing dataTask")
                completionHandler(error)
                return
            }
            guard let data = data else {fatalError("Could not get data in 'GET' request.")}
            DispatchQueue.main.async {
                do {
                    var entryRepresentations: [EntryRepresentation] = []
                    let results = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                    entryRepresentations = Array(results.values)
                    for entryRepresentation in entryRepresentations {
                        let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRepresentation.identifier)
                        if entry != nil {
                            self.update(entry: entry!, entryRepresentation: entryRepresentation)
                        } else {
                            _ = Entry(entryRepresentation: entryRepresentation)
                        }
                    }
                    self.saveToPersistentStore()
                    completionHandler(nil)
                    
                } catch {
                print("error performing dataTask in fetchEntriesFromServer")
                }
            }
            }.resume()
    }
    
    
}
