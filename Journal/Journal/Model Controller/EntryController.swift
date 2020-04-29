//
//  EntryController.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/29/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
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

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://journal-e67ab.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping CompletionHandler) {
        
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL
            .appendingPathExtension(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let entryRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
            
        } catch {
            
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
            
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
        
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in}) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                NSLog("Error: No data returned from entry.")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                try self.updateEntries(with: entryRepresentations)
                
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        
        let representationsByID = Dictionary(uniqueKeysWithValues:
            zip(identifiersToFetch, representations)
        )
        
        var entriesToCreate = representationsByID
        
        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timestamp = representation.timestamp
                entry.mood = representation.mood
                
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
        } catch {
            NSLog("Error fetching entries for UUIDs: \(error)")
        }
        
        try self.saveToPersistentStore()
    }
    
    func saveToPersistentStore() throws {
        let context = CoreDataStack.shared.mainContext
        try context.save()
    }
    
}
