//
//  EntryController.swift
//  Journal
//
//  Created by Isaac Lyons on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://journal-5d828.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in } ) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry.")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry representation is nil")
            completion(NSError())
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in } ) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry.")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error getting entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task.")
                completion(NSError())
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let context = CoreDataStack.shared.mainContext
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let identifiersToFetch = representations.map({ $0.identifier })
        var representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let identifier = entry.identifier,
                        let representation = representationsByID[identifier] else { continue }
                    
                    update(entry: entry, representation: representation)
                    
                    representationsByID.removeValue(forKey: identifier)
                }
                
                for representation in representationsByID.values {
                    Entry(entryRepresentation: representation, context: context)
                }
                
                save(context: context)
            } catch {
                NSLog("Error fetching existing entries: \(error)")
            }
        }
    }
    
    func update(entry: Entry, representation entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
    }
    
    func save(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
            }
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: EntryMood, context: NSManagedObjectContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        save(context: context)
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: EntryMood, context: NSManagedObjectContext) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        save(context: context)
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry, context: NSManagedObjectContext) {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        save(context: context)
    }
    
}
