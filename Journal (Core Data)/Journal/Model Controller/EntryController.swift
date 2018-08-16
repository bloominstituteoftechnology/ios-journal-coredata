//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - CRUD
    
    func create(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        
        saveToCoreData()
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp //*
        entry.mood = mood
        
        put(entry: entry)
        
        saveToCoreData()
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)

        saveToCoreData()
    }
    
    // MARK: - DataBase
    
    static let baseURL = URL(string: "https://journalday3.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchSingleEntryFromPersistentStore(withUUID uuid: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with uuid \(uuid): \(error)")
            return nil
        }
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp  // timestamp is being updated in the CRUD update()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = EntryController.baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entry from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data entry")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                var entryRepresentations: [EntryRepresentation] = []
                let decodedEntries = try JSONDecoder().decode([String : EntryRepresentation].self, from: data)
                entryRepresentations = decodedEntries.map { $0.value }
                
                for entryRepresentation in entryRepresentations {
                    
                    // Compare the entry representation to see if there is an entry in the persistentStore alreayd with the same uuid
                    guard let uuid = UUID(uuidString: entryRepresentation.identifier)?.uuidString else { return }
                    
                    DispatchQueue.main.async {
                        let entry = self.fetchSingleEntryFromPersistentStore(withUUID: uuid)
                        
                        // Check to see if entry from persistentStore exist
                        if let entry = entry {
//                            if entry == entryRepresentation {
//                                return
//                            } else { //if entry != entryRepresentation {
//                                self.update(entry: entry, with: entryRepresentation)
//                            }
                            
                            if entry != entryRepresentation {
                                self.update(entry: entry, with: entryRepresentation)
                            }
                        } else {
                            // No entry returned from persistentStore means that the server has an entry that the device doesn't. Initialize new Entry
                            Entry(entryRepresentation: entryRepresentation)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.saveToCoreData()
                }
            } catch {
                NSLog("Error decoding entry representations: \(error)")
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
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        // Get the entry's identifier, or if it doesn't have one, create a new uuid
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = EntryController.baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(error)
            return
        }
        
        // Tells server to fulfill the request
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
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
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = EntryController.baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETing entry from server: \(error)")
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
    
    // MARK: - Persistence
    
    func saveToCoreData() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving entry: \(error)")
        }
    }
}
