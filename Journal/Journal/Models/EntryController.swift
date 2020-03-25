//
//  EntryController.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    typealias CompletionHandler = (Error?) -> Void
    
    let baseURL = URL(string: "https://journal-83f39.firebaseio.com/")!
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object contect: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, timestamp: Date, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, context: CoreDataStack.shared.mainContext)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(title: String, bodyText: String, mood: String, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
    }

    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
             guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            try CoreDataStack.shared.mainContext.save()
            
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            NSLog("Error encoding/saving task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
}






//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        do {
//            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//        } catch {
//            NSLog("Error saving managed object contect: \(error)")
//            return []
//        }
//    }
