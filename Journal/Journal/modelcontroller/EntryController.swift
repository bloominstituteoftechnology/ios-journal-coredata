//
//  EntryController.swift
//  Journal
//
//  Created by Vincent Hoang on 5/20/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
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
    private let baseURL: URL = URL(string: "https://journal-1f869.firebaseio.com/")!
    
    func sendEntryToServer(_ entry: Entry, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
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
                NSLog("Error decoding entries from Firebase: \(error)")
                completion(.failure(.failedDecode))
            }
        }
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
            guard let id = entry.identifier, let representation = representationsByID[id] else {
                continue
            }
            
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
        entry.timeStamp = representation.timeStamp
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
    }
}
