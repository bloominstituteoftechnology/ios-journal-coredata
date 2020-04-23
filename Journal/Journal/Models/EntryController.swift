//
//  EntryController.swift
//  Journal
//
//  Created by Mark Poggi on 4/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
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

let baseURL = URL(string: "https://journal-5b606.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data return from fetch")
                completion(.failure(.noData))
                return
            }
            //            print(String(data:data,encoding: .utf8))
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([ String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(.success(true))
            } catch {
                NSLog("error decoding entries from server: \(error)")
                completion(.failure(.noDecode))
                
            }
        }.resume()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"  // POST creates a new record on the server EVEN if it already exists - always ADDs.  PUT says create if not there, overwrite/replace if it exists.
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody  = try JSONEncoder().encode(representation)
        } catch {
            NSLog("error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("error sending entry to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            //            if let response = response as? HTTPURLResponse,
            //                response.statusCode != 200 {
            //
            //            }
            
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
                
            }
            
            completion(.success(true))
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier)}
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
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
                       NSLog("Error fetching entries with UUIDs: \(identifiersToFetch), with error: \(error)")
                   }
               }
           }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        
    }
}
