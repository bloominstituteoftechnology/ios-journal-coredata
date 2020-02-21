//
//  EntryController.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit
import CoreData


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

let baseURL = URL(string: "https://journalapp-12797.firebaseio.com/")!

class EntryController {
    
    // type alias - sort of shortcut for function - put outsude class to use throughout class.
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesfromServer()
    }
    
    // Old Basic method not efficient
//    var entries: [Entry]
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Error Fetching Entries: \(error)")
//            return []
//        }
//    }

    
    // Fetch Tasks from Firebase server
    func fetchEntriesfromServer(completion: @escaping CompletionHandler =  { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else { // guard against error right away
                print("Error fetching taks: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No Data Returned by Data Task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            do {
                // decode data ,,in form of dictonary
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                // UPDATE ENTRIES TO SERVER
                try self.updateEntries(with: entryRepresentations)
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding task representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }
   
         // Update Entry on Firebase
        func updateEntries(with representations: [EntryRepresentation]) throws {
            let entriesWithID = representations.filter { $0.identifier != nil }
            let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier!) }
            // in Firebase the Key is the UUID and the Value is the Entry Object
            let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
            var entriesToCreate = representationsByID
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            // Grab entries from Firebase
//            let context = CoreDataStack.shared.mainContext - Remove Duplicate of below
            let context = CoreDataStack.shared.container.newBackgroundContext()
            context.performAndWait {
                do {
                    
                    let existingEntries = try context.fetch(fetchRequest)
                    for entry in existingEntries {
                        guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                        self.update(entry: entry, with: representation)
                        entriesToCreate.removeValue(forKey: id)
                     }
                    //for anything left over crete new task
                    for representation in entriesToCreate.values {
                        Entry(entryRepresentation: representation, context: context)
                    }
                } catch {
                    print("Error fetching task for UUIDs: \(error)")
                }
                do {
                   try CoreDataStack.shared.save(context: context)
                } catch {
                    print(NSError())
                }
                }
//            try self.saveToPersistentStore() -- old way
        }
    
    // update Entry for Firebase
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodytext = representation.bodytext
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        // DONT NEED to add identifier - Already checked earlier in update entires.
    }
    
    // PUT - send Entries to Firebase -- Changed name of function from "put" to "sendTasksToServer"
    func sendTasksToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier?.uuidString else { return }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else { completion(NSError())
            return }
            representation.identifier = identifier
//            try saveToPersistentStore() - OLD
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion(error)
            return
        }
        
        // send new task to Firebase API
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error PUTing tasks to server: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                    completion(nil)
            }
        }.resume()
    }
    
    // Delete Entry from Server
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil else {
                print("Error deleting task: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
        
    }
    
    // Save to Persostent Store == Removed to allow concurrency
    
//    func saveToPersistentStore() {
//        do {
//            let moc = CoreDataStack.shared.mainContext
//            try moc.save()
//        } catch {
//            print("Error Saving Task: \(error)")
//        }
//    }
    
    // - CRUD
    // create Entry
    func CreateEntry(title: String, bodytext: String, mood: String, timestamp: Date, identifier: UUID) {
        let entry = Entry(title: title, bodytext: bodytext, mood: mood, timestamp: timestamp, identifier: identifier)
        sendTasksToServer(entry: entry)
//        saveToPersistentStore()
        
    }
    
    //Update Entry
    func Update(entry: Entry, newTitle: String, newMood: String, newBodyText: String, updatedTimeStamp: Date) {
        let updatedTimeStamp = Date()
        entry.title = newTitle
        entry.bodytext = newBodyText
        entry.timestamp = updatedTimeStamp
        entry.mood = newMood
        sendTasksToServer(entry: entry)
//        saveToPersistentStore()
        
    }
    

        
    //Delete Entry
    
    func Delete(entry: Entry) {
//        deleteEntryFromServer(entry: entry) USE THIS IN TABLEVIEWCONTROLLER
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
//            saveToPersistentStore()
        } catch {
            moc.reset()
            print("Error saving deleted entry: \(error)")
        }
    }

}

 
