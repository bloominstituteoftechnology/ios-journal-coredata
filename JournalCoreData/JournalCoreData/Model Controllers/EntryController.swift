//
//  EntryController.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://journal-core-data-6cb21.firebaseio.com")!
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error save managed ibject context: \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        do {
//            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching Entries: \(error)")
//            return []
//        }
//        
//    }
    
    func createEntry(title: String, body: String, mood: String) {
        let entry = Entry(title: title, bodyText: body, timestamp: Date(), mood: mood, identifier: UUID().uuidString)
        saveToPersistentStore()
        if let entryRepresentation = entry.entryRepresentation {
            put(entry: entryRepresentation)
        }
        
        
    }
    
    func update(entry: Entry, title: String, body: String, mood: String) {
        entry.title = title
        entry.bodyText = body
        entry.mood = mood
        saveToPersistentStore()
        if let entryRepresentation = entry.entryRepresentation {
            put(entry: entryRepresentation)
        }
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        if let entryRepresentation = entry.entryRepresentation {
            deleteEntryFromServer(entry: entryRepresentation)
        }
        saveToPersistentStore()
        
    }
    
    func put(entry: EntryRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(entry.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let json = try JSONEncoder().encode(entry)
            request.httpBody = json
        } catch {
            NSLog("Error Encoding json from entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error putting entry: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                // we have a successful response
                completion(nil)
            }
            
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: EntryRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(entry.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error putting entry: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                // we have a successful response
                completion(nil)
            }
            
        }.resume()
        
        
    }
    
    
}
