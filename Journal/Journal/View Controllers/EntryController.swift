//
//  JournalController.swift
//  Journal
//
//  Created by David Williams on 4/26/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class EntryContoller {
    
    init() {
        fetchEntriesFromServer()
    }
    
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://journal-fc20b.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier =  entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let entryRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(.failure(.noEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
            return
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let removeURL = baseURL.appendingPathExtension("\(String(describing: entry.identifier))").appendingPathComponent("json")
        var request = URLRequest(url: removeURL)
               request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
        }.resume()
    }
    
    func update(entry: Entry, representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
    
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        
        let representationsByID = Dictionary(uniqueKeysWithValues:
            zip(identifiersToFetch, representations)
        )
        
        // Make a copy of representationsByID for later use
        var entriesToCreate = representationsByID
        
        // Ask Core Data to find any tasks with these identifiers
    
        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            // This will only fetch the entries that match the criteria in our predicate
            let existingEntries = try context.fetch(fetchRequest)
            
            // Let's update the entries that already exist in Core Data
            
            for entry in existingEntries {
                
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timestamp = representation.timestamp
                entry.mood = representation.mood
                
                // If we updated the entry, that means we don't need to make a copy of it. It already exists in Core Data, so remove it from the entries we still need to create
                
                entriesToCreate.removeValue(forKey: id)
            }
            // Add entries that don't exist
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
        } catch {
            NSLog("Error fetching tasks for UUIDs: \(error)")
        }
        try self.saveToPersistentStore()
    }
   
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
               request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                NSLog("Error: No data returned from fetch")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            // Pull the JSON out of the data, and turn it into [EntryRepresentation]
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                // Figure out which entry representions don't exist in Core Data, so we can add them and figure out which ones have changed
                try self.updateEntries(with: entryRepresentations)
                
                completion(.success(true))
            } catch {
                NSLog("Error decoding entry representation: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }
    
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}
