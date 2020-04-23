//
//  EntryController.swift
//  Journal
//
//  Created by Hunter Oppel on 4/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noRep
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
}

enum HTTPMethod: String {
    case put = "PUT"
    case delete = "DELETE"
}

let baseURL: URL = URL(string: "https://journal-c85b9.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                NSLog("Failed fetch with error: \(error)")
                return completion(.failure(.otherError))
            }
            guard let data = data else {
                NSLog("Fetch returned with no data.")
                return completion(.failure(.noData))
            }
            
            do {
                let entryRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                self.updateEntries(with: entryRepresentation)
                completion(.success(true))
            } catch {
                NSLog("Failed to decode data from server with error: \(error)")
                completion(.failure(.noDecode))
            }
        }
        .resume()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            NSLog("Entry \(entry) had no identifier.")
            return completion(.failure(.noIdentifier))
        }
        
        var request = apiRequest(uuid: uuid, method: .put)
        do {
            guard let representation = entry.entryRepresentation else {
                NSLog("Unable to get rep from entry \(entry)")
                return completion(.failure(.noRep))
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Failed to encode entry \(entry): \(error)")
            return completion(.failure(.noEncode))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Session returned with error: \(error)")
                return completion(.failure(.otherError))
            }
            
            completion(.success(true))
        }
        .resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            NSLog("Entry \(entry) had no identifier.")
            return completion(.failure(.noIdentifier))
        }
        
        let request = apiRequest(uuid: uuid, method: .delete)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Session return with error: \(error)")
                return completion(.failure(.otherError))
            }
            
            completion(.success(true))
        }
        .resume()
    }
    
    // MARK: - Helper Methods
    
    private func apiRequest(uuid: UUID, method: HTTPMethod) -> URLRequest {
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var tasksToCreate = representationsById
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsById[id] else { continue }
                    
                    self.update(entry: entry, entryRepresentation: representation)
                    tasksToCreate.removeValue(forKey: id)
                }
                
                for representation in tasksToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
                
                try context.save()
            } catch {
                NSLog("Failed to fetch entries \(identifiersToFetch) with error: \(error)")
                return
            }
        }
    }
    
    private func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
    }
}
