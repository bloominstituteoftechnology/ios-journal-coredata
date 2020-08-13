//
//  EntryController.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/11/20.
//  Copyright © 2020 Lambda. All rights reserved.
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

let baseURL = URL(string: "https://iosjournalproject2.firebaseio.com/")!

typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

class EntryController {
    
    
    func fetchEntriesFromServer() {
     
    }
    
    //Put the task to the server
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
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
            print("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error PUTting task to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }
        
        task.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
        completion(.failure(.noIdentifier))
        return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                print(response!)
                completion(.success(true))
            }
            
            task.resume()
        }
        
        
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap({UUID(uuidString: $0.identifier)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
        let existingTasks = try context.fetch(fetchRequest)
        
        // Update Existing
        for entry in existingTasks {
            guard let id = entry.identifier,
                let representation = representationsByID[id] else { continue }
            
            entry.title = representation.title
            entry.bodyText = representation.bodyText
            entry.mood = representation.mood
            entry.timestamp = representation.timestamp
            
            entriesToCreate.removeValue(forKey: id)
            
        }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            print("Error fetching entries for UUIDs: \(error)")
        }
        try CoreDataStack.shared.mainContext.save()
        
    }
    
    
    func update(entry: Entry) {
        
    }
        
    
    
    
    
    
    
    
    

}
    

    


