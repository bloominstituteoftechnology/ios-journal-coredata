//
//  EntryController.swift
//  Journal
//
//  Created by Ufuk Türközü on 24.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching data: \(error)")
//            return []
//        }
//    }
    
    let baseURL = URL(string: "https://journalios14.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries from Firebase: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from Firebase")
                completion(NSError())
                return
            }
            
            do {
                //let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                try self.updateServer(with: entryRepresentations)
                completion(nil)
            } catch {
                NSLog("Error decoding entry representations from Firebase: \(error)")
                completion(error)
                return // needed in catch?
            }
        }.resume()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.id ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.id = uuid
            entry.id = uuid
            try CoreDataStack.shared.mainContext.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entries: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func updateServer(with representation: [EntryRepresentation]) throws {
        let identifiersToFetch = representation.compactMap({ UUID(uuidString: $0.id)})
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representation))
        var entriesToCreate = representationByID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.id, let representation = representationByID[UUID(uuidString: id) ?? UUID()] else { continue }
                    self.update(entry: entry,
                                with: representation.title,
                                timestamp: representation.timestamp,
                                bodyText: representation.bodyText ?? "",
                                mood: EntryMood(rawValue: representation.mood)!)
                    
                    entriesToCreate.removeValue(forKey: UUID(uuidString: id) ?? UUID())
                    
                    for representation in entriesToCreate.values {
                        Entry(entryRepresentation: representation, context: context)
                    }
                }
            } catch {
                NSLog("Error fetching tasks for UUIDs: \(error)")
            }
        }
        CoreDataStack.shared.save(context: context)
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.id else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            
            do {
                let entry = try JSONDecoder().decode([EntryRepresentation].self, from: data)
                completion(nil)
            } catch {
                completion(error)
                return
            }
        }.resume()
    }
    
    // MARK: - CRUD
    
    @discardableResult func create(with title: String, timestamp: Date, bodyText: String, mood: EntryMood, id: String) -> Entry {
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, mood: mood, id: id, context: CoreDataStack.shared.mainContext)
        put(entry: entry)
        CoreDataStack.shared.save()
        return entry
    }
    
    @discardableResult func update(entry: Entry, with title: String, timestamp: Date, bodyText: String, mood: EntryMood) -> Entry {
        entry.title = title
        entry.timestamp = timestamp
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        
        put(entry: entry)
        CoreDataStack.shared.save()
        return entry
    }
}
