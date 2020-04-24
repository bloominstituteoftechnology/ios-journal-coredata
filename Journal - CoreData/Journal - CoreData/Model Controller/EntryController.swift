//
//  EntryController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//
import Foundation
import UIKit

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
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch")
                completion(.failure(.noData))
                return
            }
            
            var entries: [EntryRepresentation] = []
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                entries = entryRepresentations
                self.updateEntries(with: entryRepresentations)
                completion(.success(true))
                return
            } catch {
                NSLog("Error decoding entries from server: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
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
        
        let identifiersToFetch = representations.compactMap { $0.identifier }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
                
            }
            saveToPersistentStore()
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            saveToPersistentStore()
            try CoreDataStack.shared.mainContext.save()
        }catch {
            NSLog("Error fetching tasks with IDs: \(identifiersToFetch), with error: \(error)")
        }
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.identifier = representation.identifier
        entry.timestamp = representation.timestamp
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
    }
    
    
    //    var entry: Entry?
    //
        func saveToPersistentStore() {
            
//            guard entry != nil else { return }

            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
                return
            }
    
        }
    //
    //    func loadFromPersistentStore() -> [Entry] {
    //        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    //        let context = CoreDataStack.shared.mainContext
    //        do {
    //            return try context.fetch(fetchRequest)
    //        } catch {
    //            NSLog("Error fetching entries: \(error)")
    //            return []
    //        }
    //    }
    //
    //    var entries: [Entry] {
    //           loadFromPersistentStore()
    //          }
    //
    //    func create(title: String, timestamp: Date, bodyText: String, mood: String) {
    //
    //        let _ = Entry(title: title, timestamp: timestamp, mood: mood)
    //
    //        do {
    //            try CoreDataStack.shared.mainContext.save()
    //        } catch {
    //            NSLog("Error creating new managed object context: \(error)")
    //        }
    //
    //        saveToPersistentStore()
    //    }
    //
    //    func update(title: String, timestamp: Date, bodyText: String, mood: String) {
    //
    //        entry?.title = title
    //        entry?.bodyText = bodyText
    //        let date = Date()
    //        entry?.timestamp = date
    //        entry?.mood = mood
    //
    //        saveToPersistentStore()
    //
    //    }
    //
    //    func delete(entry: Entry) {
    //
    //        CoreDataStack.shared.mainContext.delete(entry)
    //
    //        do {
    //            try CoreDataStack.shared.mainContext.save()
    //        } catch {
    //            NSLog("Error deleting the entry: \(error)")
    //            return
    //        }
    //    }
}
