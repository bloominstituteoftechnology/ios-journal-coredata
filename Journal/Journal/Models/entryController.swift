//
//  entryController.swift
//  Journal
//
//  Created by Dahna on 4/22/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
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

let baseURL = URL(string: "https://journal-89a2a.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending entry to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                NSLog("Error deleting task from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
        if let error = error {
            NSLog("Error fetching tasks: \(error)")
            completion(.failure(.otherError))
            return
        }
            guard let data = data else {
                NSLog("No data returned from fetch")
                completion(.failure(.noData))
                return
            }
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(.success(true))
            } catch {
                NSLog("Error decoding entries from server: \(error)")
                completion(.failure(.noDecode))
                
            }
        }.resume()
    }

    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
                
                
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            try context.save()
        } catch {
            NSLog("Error fetching tasks with UUIDs: \(identifiersToFetch), with error: \(error)")
        }
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood = representation.mood
    }
}
