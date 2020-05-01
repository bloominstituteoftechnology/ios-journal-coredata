//
//  EntryController.swift
//  Journal
//
//  Created by Morgan Smith on 4/29/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
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
    
    let baseURL = URL(string: "https://journaldatabase-5e039.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL
            .appendingPathComponent(identifier)
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
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion(.failure(.otherError))
                return
            }
                completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //something went wrong
                NSLog("Error: status code is not the expect 200.  Instead it is \(response.statusCode)")
            }
            
            if let error = error {
                NSLog("Error Deleting entry from server: \(error)")
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
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                NSLog("Error: No data returned from data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                try self.updateEntries(with: entryRepresentations)
            
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        
        let identifiersToFetch = representations.compactMap({ ($0.identifier) })
        
        let representationsByID = Dictionary(uniqueKeysWithValues:
            zip(identifiersToFetch, representations)
        )
        
        var entriesToCreate = representationsByID
        
        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    entry.title = representation.title
                    entry.bodyText = representation.bodyText
                    entry.timestamp  = representation.timestamp
                    entry.mood = representation.mood
                    
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
                
            } catch {
                NSLog("Error fetching entries for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
        
        //try self.saveToPersistentStore()
    }
    
    /*
     func saveToPersistentStore() throws {
     let moc = CoreDataStack.shared.mainContext
     try moc.save()
     }*/
    
}
