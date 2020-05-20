//
//  EntryController.swift
//  Journal
//
//  Created by Brian Rouse on 5/20/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
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
    
    init() {
        fetchEntriesFromServer()
    }

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    // MARK: - iVars
    
    let baseURL = URL(string: "https://lambda-firebase-ab057.firebaseio.com/")!

    // MARK: - Helper Methods
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")

        
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
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error Puting task to server: \(error)")
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

    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier ))
            return
        }

        let requestURL = baseURL.appendingPathExtension(identifier).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting task in server: \(error)")
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
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
    }

    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap({ $0.identifier })

        let fetchRequest: NSFetchRequest<Entry>  = Entry.fetchRequest()

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))

        var entriesToCreate = representationsByID

        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        fetchRequest.predicate = predicate

        let context = CoreDataStack.shared.mainContext

        do {

            let existingEntries = try context.fetch(fetchRequest)

            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }

                update(entry: entry, entryRepresentation: representation)

                entriesToCreate.removeValue(forKey: id)
            }

            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }

        } catch {
            NSLog("Error fetching tasks for Identifier: \(error)")
        }

        try self.saveToPersistentStore()
    }

    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"

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

            var entryRepresentations: [EntryRepresentation] = []

            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })

                try self.updateEntries(with: entryRepresentations)

                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                NSLog("Error decoding task representations: \(error)")
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
