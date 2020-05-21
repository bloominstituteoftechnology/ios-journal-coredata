    //
    //  EntryController.swift
    //  CoreDataJournal
    //
    //  Created by Marissa Gonzales on 5/20/20.
    //  Copyright © 2020 Joe Veverka. All rights reserved.
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
    
    // Helper properties
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    let baseURL = URL(string: "https://journalcoredataday3-923ec.firebaseio.com/")!
    
    class EntryController {
        
        init() {
            fetchEntriesFromServer()
        }
        
        // Fetch
        func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
            let requestURL = baseURL.appendingPathExtension("json")
            
            URLSession.shared.dataTask(with: requestURL) { data, _, error in
                if let error = error {
                    NSLog("Error fetching tasks: \(error)")
                    completion(.failure(.otherError))
                    return
                }
                
                guard let data = data else {
                    NSLog("No data returned from Firebase (fetching entries).")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                    try self.updateEntries(with: entryRepresentations)
                } catch {
                    NSLog("Error deocding entries from Firebase: \(error)")
                    completion(.failure(.noDecode))
                }
            }.resume()
        }
        
        // Update Entries
        private func updateEntries(with representations: [EntryRepresentation]) throws {
            let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
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
                        self.update(entry: entry, with: representation)
                        entriesToCreate.removeValue(forKey: id)
                    }
                } catch let fetchError {
                    error = fetchError
                }
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            }
            if let error = error { throw error }
            try CoreDataStack.shared.save(context: context)
        }
        
        // Update Entries 2
        private func update(entry: Entry, with representation: EntryRepresentation) {
            entry.title = representation.title
            entry.bodyText = representation.bodyText
            entry.mood = representation.mood
            entry.timestamp = representation.timestamp
        }
        
        // Delete Entries
        func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
            guard let uuid = entry.identifier else {
                completion(.failure(.noIdentifier))
                return
            }
            let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { _, _ , error in
                if let error = error {
                    NSLog("Error deleting entry from server \(entry): \(error)")
                    completion(.failure(.otherError))
                    return
                }
                completion(.success(true))
            }.resume()
        }
        
        // Send entries
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
                    completion(.failure(.noEncode))
                    return
                }
                request.httpBody = try JSONEncoder().encode(representation)
            } catch {
                NSLog("Error encoding task \(entry): \(error)")
                completion(.failure(.noEncode))
                return
            }
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    NSLog("Error sending task to server \(entry): \(error)")
                    completion(.failure(.otherError))
                    return
                }
                completion(.success(true))
            }.resume()
        }
    }
