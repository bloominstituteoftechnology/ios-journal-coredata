//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    let baseURL = URL(string: "https://core-data-journal.firebaseio.com/")!
    
    // MARK - Initializers
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - CRUD Methods
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
        put(entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        
        saveToPersistentStore()
        put(entry)
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.timestamp = entryRepresentation.timestamp
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry)
        
        CoreDataStack.shared.mainContext.delete(entry)
        
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context to persistent store: \(error)")
        }
    }
    
    private func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        
        fetchRequest.predicate = predicate
        
        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching single entry from persistent store.")
            return nil
        }
    }
    
    // MARK: - Networking
    private func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetching entries from server.")
                completion(NSError())
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map() { $0.value }
                for entryRepresentation in entryRepresentations {
                    if let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRepresentation.identifier) {
                        if entry != entryRepresentation {
                            self.update(entry: entry, entryRepresentation: entryRepresentation)
                        }
                    } else {
                        _ = Entry(entryRepresentation: entryRepresentation)
                        
                    }
                }
                
                self.saveToPersistentStore()
                completion(nil)
                return
            } catch {
                NSLog("Error decoding fetched entry representations: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    private func put(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        // Unwrap the identifier
        let identifier = entry.identifier ?? UUID().uuidString
        
        // If there isn't one, set it and update the persistent store
        if entry.identifier != identifier {
            entry.identifier = identifier
            saveToPersistentStore()
        }
        
        // Make the request URL
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        // Make the request and set its HTTP Method
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    private func deleteEntryFromServer (_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier to delete enty by.")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETEing entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            return
        }.resume()
        
    }
}
