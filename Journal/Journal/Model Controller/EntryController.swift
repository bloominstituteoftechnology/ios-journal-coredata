//
//  EntryController.swift
//  Journal
//
//  Created by Matthew Martindale on 4/28/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
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
    
    let baseURL = URL(string: "https://lambdajournal-2718e.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler) {
        
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString)
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
            NSLog("Error encoding the entry: \(entry): \(error)")
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
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping () -> Void = {}) {
        guard let identifier = entry.identifier else {
            completion()
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString)
                                .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting task from server: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
        }.resume()
        
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var entriesToCreate = representationsById
        
        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsById[id] else { continue }
                
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
    
    func fetchEntriesFromServer(completion: @escaping () -> Void = {}) {
        
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
}
