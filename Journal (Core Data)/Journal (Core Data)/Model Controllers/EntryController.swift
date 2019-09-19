//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Enums

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
    // MARK: - Initializers
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - Properties
    
    var baseURL = URL(string: "https://ios-9-journal-core-data.firebaseio.com/")!
    
    //    var entries: [Entry] {
    //        return loadFromPersistentStore()
    //    }
    
    // MARK: - Methods and Functions
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting entries from Firebase: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { return }
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                let reps = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                entryRepresentations = reps.compactMap({ $0.value })
                self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                NSLog("Error Decoding entry representations on line \(#line) in \(#file): \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timeStamp = entryRepresentation.timeStamp
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let identifiersToFetch = representations.compactMap({ $0.identifier })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        let context = CoreDataStack.shared.mainContext
        var entriesToCreate = representationsByID
        
        do {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else { return }
                update(entry: entry, entryRepresentation: representation)
                entriesToCreate.removeValue(forKey: identifier)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
            saveToPersistentStore()
        } catch {
            NSLog("Error performing NSFetchRequest on line \(#line) in \(#file): \(error)")
        }
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context on line \(#line) in file \(#file): \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func putEntry(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil on line \(#line) in file \(#file)")
            completion(nil)
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error PUTting entry on line \(#line) in file \(#file): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting entry on line \(#line) in file \(#file): \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else { return }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting Entry on line \(#line) in \(#file): \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    //    func loadFromPersistentStore() -> [Entry] {
    //        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    //
    //        do {
    //            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
    //            return entries
    //        } catch {
    //            NSLog("Error fetching entries: \(error)")
    //            return []
    //        }
    //    }
    
    func createEntry(title: String, bodyText: String, timeStamp: Date, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, context: CoreDataStack.shared.mainContext)
        
        putEntry(entry: entry)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timeStamp: Date = Date(), mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = timeStamp
        entry.mood = mood.rawValue
        
        putEntry(entry: entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
}
