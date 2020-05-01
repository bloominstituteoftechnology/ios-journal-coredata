//
//  EntryController.swift
//  Journal
//
//  Created by Chad Parker on 4/28/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
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
    
    let baseURL = URL(string: "https://lambda-journal-ec0b2.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
    func sendEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
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
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                NSLog("Error PUTing entry to server: \(error!)")
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
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                NSLog("Error DELETEing entry on server: \(error!)")
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
        let url = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                NSLog("Error fetching entries from server: \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let idsAndRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let entryRepresentations = idsAndRepresentations.map { $0.value }
                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        
        let ids = representations.map { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues:
            zip(ids, representations)
        )
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", ids)
        
        let context = CoreDataStack.shared.mainContext
        do {
            let existingEntries = try context.fetch(fetchRequest)
            for entry in existingEntries {
                guard let id = entry.identifier,
                let representation = representationsByID[id] else { continue }
                
                entry.bodyText = representation.bodyText
                entry.mood = representation.mood
                entry.timestamp = representation.timestamp
                entry.title = representation.title
                
                entriesToCreate.removeValue(forKey: id)
            }
            
            try self.saveToPersistentStore()
            
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
