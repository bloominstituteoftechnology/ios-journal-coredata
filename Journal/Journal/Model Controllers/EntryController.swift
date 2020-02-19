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
        let requestURL = baseURL.appendingPathComponent("json")
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
            
    }
    }
    
    // PUT - send tasks to server
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else { return }
        entry.identifier = identifier
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else { completion(NSError())
            return }
            representation.identifier = identifier
            try saveToPersistentStore()
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
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
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
    
    
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error Saving Task: \(error)")
        }
    }
    
    // - CRUD
    // create Entry
    func CreateEntry(title: String, bodytext: String, mood: String, timestamp: Date, identifier: String) {
        let entry = Entry(title: title, bodytext: bodytext, mood: mood, timestamp: timestamp, identifier: identifier)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    //Update Entry
    func Update(entry: Entry, newTitle: String, newMood: String, newBodyText: String, updatedTimeStamp: Date) {
        let updatedTimeStamp = Date()
        entry.title = newTitle
        entry.bodytext = newBodyText
        entry.timestamp = updatedTimeStamp
        entry.mood = newMood
        put(entry: entry)
        saveToPersistentStore()
        
    }
    
     // Update Entry on server
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifierToFetch = entriesWithID.compactMap { $0.identifier! }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifierToFetch, entriesWithID))
        var entriesToCreate = representationsById
        
         let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifierToFetch)
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            for entry in existingEntries {
                guard let id = entry.identifier,
                let representation = representationsById[id] else { continue }
//                self.Update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
             }
        } catch {
            
        }
        
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

 
