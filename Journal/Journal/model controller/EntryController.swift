//
//  EntryController.swift
//  Journal
//
//  Created by ronald huston jr on 8/11/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
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

let baseURL = URL(string: "https://journal-9e197.firebaseio.com/")!

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    //  fetch entries
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                completion(.failure(.noData))
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(.success(true))
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    //  delete entry
    func deleteTaskFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.id else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
            
        }.resume()
    }
    
    // Update tasks with representations
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap({UUID(uuidString: $0.id)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            //  update existing
            for entry in existingEntries {
                guard let id = entry.id,
                    let representation = representationsByID[UUID(uuidString: id)!] else { continue }
                //  self.update()
                //  removeValue ?
            }
            
            // Create New
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            print("Error fetching entries for UUIDs: \(error)")
        }
        
        try CoreDataStack.shared.mainContext.save()
    }
    
    // Put the task to the server
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.id else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error sending entry to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
}
