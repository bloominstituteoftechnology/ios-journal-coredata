//
//  EntryController.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/13/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://journal-coredata.firebaseio.com/")!
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to core data: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, entryRep: EntryRepresentation) {
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.timestamp = entryRep.timestamp
        entry.mood = entryRep.mood
        
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry) { (error) in
            DispatchQueue.main.async {
                let moc = CoreDataStack.shared.mainContext
                moc.delete(entry)
                self.saveToPersistentStore()
            }
        }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        do {
            request.httpBody = try JSONEncoder().encode(entry)
            
        } catch {
            NSLog("Error encoding json: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting data to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error Deleting data on server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", UUID(uuidString: identifier)! as NSUUID)
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with uuid: \(identifier) \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                var entryRepresentations: [EntryRepresentation] = []
                let data = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                for data in data.values {
                    entryRepresentations.append(data)
                }
                
                for entryRep in entryRepresentations {
                    let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier)
                    
                    if let entry = entry {
                        if entry == entryRep {
                            // Do nothing here
                        } else {
                            self.update(entry: entry, entryRep: entryRep)
                        }
                        
                    } else {
                        let _ = Entry(entryRep: entryRep)
                        
                    }
                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                NSLog("Error decoding data into json: \(error)")
            }
        }.resume()
        
    }
}
