//
//  EntryController.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    let baseURL = URL(string: "https://journal-a1cc9.firebaseio.com/")!
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - CRUD methods
    
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
    
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
        deleteEntryFromServer(entry: entry)
    }
    
    func put(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let identifer = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifer).appendingPathComponent("json")
        
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
                NSLog("Error updating entry to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in}) {
        guard let identifier = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func updateFromRepresentation(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
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
        // Take the baseURL and add the "json" extension to it
        let requestURL = baseURL.appendingPathExtension("json")
        // Perform a GET URLSessionDataTask with the url you just set up
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            // In the copletion of the data task, check for errors
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            // Unwrap the data returned in the closure
            guard let data = data else {
                NSLog("No data was returned from data entry")
                completion(NSError())
                return
            }
            // Create a variable of type [EntryRepresentation]. Set its initial value to an empty array
            var entryRepresentations: [EntryRepresentation] = []
            // Decode the data into [String: EntryRepresentation].self
            do {
                // Set the value of the array you just made in the previous step to the entry representations in this decoded dictionary. HINT: loop through the dictionary to return an array of just the entry representations without the identifier keys
                entryRepresentations = try Array(JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
            }
            catch {
                NSLog("Error decoding JSON: \(error)")
                completion(error)
                return
            }
            // Loop through the array of entry representations. Inside the loop, create a constant called entry. For its value, give it the result of the fetchSingleEntryFromPersistentStore method. Pass in the entry representation's identifier. This will allow us to compare the entry representation and see if there is a corresponding entry in the persistent store already.
            for entryRepresentation in entryRepresentations {
                
                guard let identifier = entryRepresentation.identifier else { continue }
                
                if let entry = self.fetchSingleEntryFromPersistentStore(with: identifier) {
                    // If the entry exists, but the entry and the entry's representation's values are not the same, then call the new update(entry: ...) method that takes in an entry and an entry representation. This will then synchronize the entry from the persistent store to the updated values from the server's version of the entry.
                    self.updateFromRepresentation(entry: entry, entryRepresentation: entryRepresentation)
                } else {
                    // If there was no entry returned from the persistent store, that means the server has an entry that the device does not. In that case, initialize a new Entry using the convenience initializer that takes in an Entry Representation
                    let _ = Entry(entryRepresentation: entryRepresentation)
                }
            }
            // Outside of the loop, call saveToPersistentStore() to persist the changes and effectively synchronize the data in the device's persistent store with the data on the server
            self.saveToPersistentStore()
            // call completion and pass in nil for the error
            completion(nil)
            // Resume the data task
        }.resume()
    }
    
}
