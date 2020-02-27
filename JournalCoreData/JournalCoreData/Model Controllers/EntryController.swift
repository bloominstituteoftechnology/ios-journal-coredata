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
    
    let baseURL = URL(string: "https://journal-core-data-6cb21.firebaseio.com/")!
    
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
    
    init() {
        fetchEntriesFromServer()
    }
    
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
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        Entry(entryRepresentation: entryRepresentation)
        
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        do {
            let existingEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            
            // match the managed entries with the firebase entries
            for entry in existingEntries {
                guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                self.update(entry: entry, entryRepresentation: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation)
            }
            
            saveToPersistentStore()
            
        } catch {
            NSLog("Error fetching entries for UUIS's: \(error)")
        }
        
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        print(requestURL)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching entires from firebase: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error with data from firebase:")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                
                self.updateEntries(with: entryRepresentations)
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding entry representations from firebase: \(error)")
                completion(error)
            }
        }.resume()
        
    }
    
    
}
