//
//  EntryController.swift
//  Journal
//
//  Created by Nonye on 5/20/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case failedDecode
    case failedEncode
}

class EntryController {
 
    let baseURL = URL(string: "https://journal-5e323.firebaseio.com/")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
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
                completion(.failure(.noData))
                return
            }
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding task \(error)")
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending error to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherData))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        } .resume()
        
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
        
        do {
            guard let entryRepresentation = entry.entryRepresentation else {
                completion(.failure(.otherError))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.failedDecode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
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
                
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.failedDecode))
                }
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
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timeStamp  = representation.timeStamp
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
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
    
    
} // END OF CLASS
