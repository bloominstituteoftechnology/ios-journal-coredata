//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    let baseURL: URL = URL(string: "https://journal-6ef05.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }

    // MARK: - Database Methods
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        let fetchRequest = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var urlRequest = URLRequest(url: fetchRequest)
        urlRequest.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = identifier.uuidString
            entry.identifier = identifier
            try CoreDataStack.shared.save()
            urlRequest.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error saving context or encoding entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            if let error = error {
                NSLog("Error sending (PUT) entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func delete(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        let fetchRequest = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var urlRequest = URLRequest(url: fetchRequest)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            if let error = error {
                NSLog("Error deleting (DELETE) entry from server: \(error)")
                completion(error)
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by dataTask")
                completion(NSError())
                return
            }
            
            var representations: [EntryRepresentation] = []
            do {
                let entriesDict = try JSONDecoder().decode([String : EntryRepresentation].self, from: data)
                
                for entry in entriesDict {
                    representations.append(entry.value)
                }
                
                try self.updateEntries(with: representations)
            } catch {
                NSLog("Error decoding or saving data from Firebase: \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
    
    // MARK: - CRUD
    func createEntry(title: String,
                     bodyText: String,
                     timestamp: Date,
                     mood: String,
                     context: NSManagedObjectContext) {
        let newEntry = Entry(title: title,
                             bodyText: bodyText,
                             timestamp: timestamp,
                             mood: mood)
        context.insert(newEntry)
        put(entry: newEntry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        let context = CoreDataStack.shared.mainContext
        let identifier = entry.identifier ?? UUID()
        let newEntry = Entry(identifier: identifier, title: title, bodyText: bodyText, timestamp: Date(), mood: mood, context: context)
        context.delete(entry)
        context.insert(newEntry)
        put(entry: newEntry)
    }
    
    func update(entry: Entry, with entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        let entriesByID = representations.filter { $0.identifier != nil }
        let entriesToFetch = entriesByID.compactMap { UUID(uuidString: $0.identifier!) }
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", entriesToFetch)
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(entriesToFetch, entriesByID))
        var entriesToCreate = representationsByID
        
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
                
            } catch {
                NSLog("Error fetching entries for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
    }
    
    func deleteEntry(entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        delete(entry: entry)
        context.delete(entry)
    }
}

