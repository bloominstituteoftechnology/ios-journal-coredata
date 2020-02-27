//
//  EntryController.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethods: String {
    case put = "PUT"
    case get = "GET"
}

enum APIErrors: Error {
    case badURL
    case otherError
    case badData
    case badImage
    case putError
    case encodeError
}

class EntryController {
    
    // MARK: - Properties
    
    var entries: [Entry] = []
    let fireBaseURL: URL = URL(string: Keys.firebaseURL)!
    let pathExtension: String = "json"
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Initializers
    
    init() {
        fetchEntriesFromServer()
    }
    
    
    // MARK: - CRUD Methods
    
    func createEntry(title: String, bodyText: String, mood: String) {
        
        let newEntry = Entry(title: title,
                             bodyText: bodyText,
                             timestamp: Date(),
                             identifier: UUID(),
                             mood: mood)
        entries.append(newEntry)
        saveToPersistence()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistence()
    }
    
    func update(entry: Entry, representation: EntryRepresenation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
    
    // MARK: - API Methods
    
        func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
            
            let identifier = entry.identifier
            entry.identifier = identifier
            
            let requestURL = fireBaseURL
                .appendingPathComponent(identifier!)
                .appendingPathExtension(pathExtension)
    
            var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethods.put.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let entryRepresentation = entry.entryRepresentation else {
                NSLog("Entry representation is nil")
                completion(APIErrors.otherError)
                return
            }
            
            do{
                request.httpBody = try JSONEncoder().encode(entryRepresentation)
            } catch {
                NSLog("Error encoding entry represenation: \(error)")
                completion(APIErrors.encodeError)
                return
            }
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    NSLog("Error PUTting entry: \(error)")
                    completion(APIErrors.otherError)
                    return
                }
            }.resume()
        }
    
    private func updateEntries(with representations: [EntryRepresenation]) throws {
        
        let identifiersToFetch = representations.compactMap {
            UUID(uuidString: $0.identifier)
        }
        
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch,
                                                                      representations))
        var entriesToCreate = representationByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@",
                                             identifiersToFetch)
        
        do{
            let existingEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = UUID(uuidString: "\(entry.identifier!)"),
                    let representation = representationByID[id] else {
                        continue
                }
                self.update(entry: entry,
                            representation: representation)
                entriesToCreate.removeValue(forKey: id)
                
            }
            for representation in entriesToCreate.values {
                Entry(representation: representation)
            }
        } catch {
            NSLog("Error fetching entries: \(error)")
        }
        saveToPersistence()
    }
    
    // why have the syntax after CompletionHander?
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = fireBaseURL.appendingPathExtension(pathExtension)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethods.get.rawValue
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                
                
                completion(APIErrors.otherError)
                NSLog("Error receiving entry data: \(error)")
                return
            }
            guard let data = data else {
                completion(APIErrors.badData)
//                NSLog("Bad data: \(error)")
                return
            }
            
            do{
                var representationArray: [EntryRepresenation] = []
                let newEntry = try JSONDecoder().decode([String: EntryRepresenation].self,
                                                        from: data)
                for representation in newEntry{
                    representationArray.append(representation.value)
                    
                }
                try self.updateEntries(with: representationArray)
                completion(nil)
            } catch {
            }
        }.resume()
    }
    
    
    // MARK: - Persistence
    
    
    private func loadFromPersistence() {
        
        var entries: [Entry]{
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            do {
                return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            } catch {
                NSLog("Error fetching entries: \(error)")
                return []
            }
        }
    }
}
