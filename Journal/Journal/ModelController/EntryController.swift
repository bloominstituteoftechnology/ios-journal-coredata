//
//  EntryController.swift
//  Journal
//
//  Created by Stephanie Ballard on 5/20/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case failedDecode
    case failedEncode
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-ios17.firebaseio.com/")!
    
    typealias CompletionHander = (Result<Bool, NetworkError>) -> Void
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHander = { _ in }) {
        guard let uuid = entry.identifier else {
            print("No identifier found")
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                print("Entry unable to be encoded")
                completion(.failure(.failedEncode))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion(.failure(.failedEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error sending task to server \(entry): \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHander = { _ in }) {
        guard let uuid = entry.identifier else {
            print("No identifier found for this entry.")
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error deleting entry from server \(entry): \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
        
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
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
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
    }
}
