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
    
    func put(entry: Entry, completion: @escaping () -> Error? = { () -> Error? in return nil} ) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry.")
            let _ = completion()
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry representation is nil")
            let _ = completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            let _ = completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                let _ = completion()
                return
            }
            
            let _ = completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping  () -> Error? = { () -> Error? in return nil} ) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry.")
            let _ = completion()
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
                let _ = completion()
                return
            }
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping  () -> Error? = { () -> Error? in return nil}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error getting entries: \(error)")
                let _ = completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task.")
                let _ = completion()
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.updateEntries(with: entryRepresentations)
            } catch {
                NSLog("Error decoding entry representations: \(error)")
            }
            
            let _ = completion()
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let context = CoreDataStack.shared.mainContext
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let identifiersToFetch = representations.map({ $0.identifier })
        var representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
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
            
            saveToPersistentStore()
        } catch {
            NSLog("Error fetching existing entries: \(error)")
        }
    }
    
    func update(entry: Entry, representation entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: EntryMood, context: NSManagedObjectContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
}
