//
//  EntryController.swift
//  Journal - Core Data
//
//  Created by Lisa Sampson on 8/20/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood = .neutral) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateFromRepresentation(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func put(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        guard let identifier = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        }
        catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        guard let identifier = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing entry fromserver: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func fetchSingleEntryFromPersistentStore(with identifier: String) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        
        fetchRequest.predicate = predicate
        
        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
        }
        catch {
            NSLog("Error fetching single entry: \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data entry")
                completion(NSError())
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = try Array(JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
            }
            catch {
                NSLog("Error decoding JSON: \(error)")
                completion(error)
                return
            }
            
            for entryRepresentation in entryRepresentations {
                
                guard let identifier = entryRepresentation.identifier else { continue }
                
                if let entry = self.fetchSingleEntryFromPersistentStore(with: identifier) {
                    self.updateFromRepresentation(entry: entry, entryRepresentation: entryRepresentation)
                } else {
                    let _ = Entry(entryRepresentation: entryRepresentation)
                }
            }
            self.saveToPersistentStore()
            completion(nil)
        }.resume()
    }
    
    let moc = CoreDataStack.shared.mainContext
    let baseURL = URL(string: "https://journal-core-data.firebaseio.com/")!
    
}
