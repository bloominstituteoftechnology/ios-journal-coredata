//
//  EntryController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

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
    
    let baseURL = URL(string: "https://coredata-journal.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
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
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error sending task to server: \(error)")
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
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier)}
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                En
            }
        }catch {
            
        }
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.identifier = representation.identifier
        entry.timestamp = representation.timestamp
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
    }
}
