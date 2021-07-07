//
//  EntryController.swift
//  Journal
//
//  Created by Samantha Gatt on 8/13/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://samanthasjournalcoredata.firebaseio.com/")!
    
    // MARK: - CRUD
    
    func create(title: String, body: String?, mood: EntryMood) {
        let entry = Entry(title: title, body: body, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, body: String?, mood: EntryMood, timestamp: Date = Date()) {
        entry.title = title
        entry.body = body
        entry.mood = mood.rawValue
        entry.timestamp = timestamp
        saveToPersistentStore()
        put(entry: entry)
    }

    func updateFromRepresentation(entry: Entry, entryRep: EntryRepresentation) {
        entry.title = entryRep.title
        entry.body = entryRep.body
        entry.mood = entryRep.mood
        entry.timestamp = entryRep.timestamp
        // Probably don't have to include this one since it should never be changed
        entry.identifier = entryRep.identifier
    }
    
    func delete(entry: Entry) {
        // Needs to delete from server first
        deleteFromServer(entry: entry)
        CoreDataStack.moc.delete(entry)
        saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    func saveToPersistentStore(context: NSManagedObjectContext = CoreDataStack.moc) {
        context.performAndWait {
            do {
                try context.save()
            }
            catch {
                NSLog("Error saving entry: \(error)")
            }
        }
    }

    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with identifier \(identifier): \(error)")
            return nil
        }
    }
    
    
    // MARK: - Networking
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        // Every entry should have an identifier since they can't be made without one so I force unwrapped it
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            
            do {
                let entryRepDicts = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                try self.updateEntries(for: entryRepDicts, context: backgroundContext)
                completion(nil)
            } catch {
                completion(error)
                return
            }
        }.resume()
    }
    
    
    // MARK: - Functions
    
    func updateEntries(for entryRepDicts: [String: EntryRepresentation], context: NSManagedObjectContext) throws {
        
        context.performAndWait {
            
            for entryRep in entryRepDicts.values {
                let entry = fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: context)
                if let entry = entry {
                    if entry != entryRep {
                        self.updateFromRepresentation(entry: entry, entryRep: entryRep)
                    }
                } else {
                    _ = Entry(entryRep: entryRep, context: context)
                }
            }
            
            saveToPersistentStore(context: context)
        }
    }
}
