//
//  EntryController.swift
//  Journal
//
//  Created by Kelson Hartle on 5/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
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
    
    let baseURL = URL(string: "https://journal-e990c.firebaseio.com/")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let jsonDecoder = JSONDecoder()
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from Firebase (fetching entries).")
                completion(.failure(.noData))
                return
            }
            
            do {
                //unecessary//self.jsonDecoder.dateDecodingStrategy = .secondsSince1970
                let entryRepresentations = Array(try self.jsonDecoder.decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
            } catch {
                NSLog("Error deocding entries from Firebase: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            representation.identifier = identifier //extra
            entry.identifier = identifier
            try CoreDataStack.shared.mainContext.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding entries \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error sending entries to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        var error: Error?
        
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    self.update(entry: entry, entryRepresentation: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
            } catch let fetchError {
                error = fetchError
            }
            // tasksToCreate should now contain FB tasks that we DON'T have in Core Data
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        }
        
        if let error = error { throw error }
        try CoreDataStack.shared.save()
    }
    
    private func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        entry.identifier = entryRepresentation.identifier
        entry.bodyText = entryRepresentation.bodyText
        entry.timeStamp = entryRepresentation.timeStamp
        entry.mood = entryRepresentation.mood
        entry.title = entryRepresentation.title
        
    }
}
