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
    
    init() {
        fetchEntriesFromServer()
    }
    
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
    
    
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            do {
                //.values will return us just the values and ignore the String key
                let entryRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                 self.updateEntries(with: entryRepresentation)
            } catch {
                NSLog("Error decoding or saving data from Firebase: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let entriesByID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesByID.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesByID))
        var tasksToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingTasks = try context.fetch(fetchRequest)
            for entry in existingTasks {
                guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                
                self.update(task: entry, with: representation)
                tasksToCreate.removeValue(forKey: id)
            }
            
            for representation in tasksToCreate.values {
                Entry(entryRepresentation: representation)
            }
            
            saveToPersistentStore()
        } catch {
            NSLog("Error fetching tasks for UUIDs: \(error)")
        }
        
    }
    
    private func update(task: Entry, with representation: EntryRepresentation) {
        task.title = representation.title
        task.bodyText = representation.bodyText
        task.mood = representation.mood
        task.timestamp = representation.timestamp
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
