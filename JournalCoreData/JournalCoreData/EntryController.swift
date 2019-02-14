//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://journalcoredata-angel.firebaseio.com/")!
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        // Create URL and URLRequest
        var url = baseURL
        url.appendPathComponent(entry.identifier!)
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Encode Entry into JSON
        let encoder = JSONEncoder()
        
        do {
            let entryJSON = try encoder.encode(entry)
            request.httpBody = entryJSON
        } catch {
            NSLog("Unable to encode entry: \(error)")
            completion(error)
        }
        
        // Perform URLSessionDataTask
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }){
        // Create URL and URLRequest
        var url = baseURL
        url.appendPathComponent(entry.identifier!)
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Perform URLSessionDataTask
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func update(_ entry: Entry, _ entryRep: EntryRepresentation){
        entry.bodyText = entryRep.bodyText
        entry.identifier = entryRep.identifier
        entry.title = entryRep.title
        entry.timestamp = entryRep.timestamp
        entry.mood = entryRep.mood
    }
    
    func fetchSingleEntryFromPersistentStore(_ identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with \(identifier): \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        var url = baseURL
        url.appendPathExtension("json")
        
        // Perform URLSessionDataTask
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error getting entries from server: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("Error unwrapping data")
                completion(error)
                return
            }
            
            var entryArray: [EntryRepresentation] = []
            
            do {
                let decoder = JSONDecoder()
                
                let entries = try decoder.decode([String: EntryRepresentation].self, from: data)
                
                for (_, entryRep) in entries {
                    entryArray.append(entryRep)
                }
                
                for entryRep in entryArray {
                    let entry = self.fetchSingleEntryFromPersistentStore(entryRep.identifier)
                    
                    guard let entryInStore = entry else {
                        _ = Entry(entryRepresenation: entryRep)
                        return
                    }
        
                    if entryInStore != entryRep {
                        self.update(entryInStore, entryRep)
                    }
                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                NSLog("Error with decoding entries: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func saveToPersistentStore(){
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
}
    
    func createEntry(title: String, bodyText: String, mood: String){
        let newEntry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(newEntry)
    }
    
    func updateEntry(title: String, bodyText: String, mood: String, entry: Entry){
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry)
        saveToPersistentStore()
    }
}
