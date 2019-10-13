//
//  EntryController.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    let baseURL: URL = URL(string: "https://lambda-ios-journal.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - Local store methods
    
    // replacing with save() method in CoreDataStack
//    func saveToPersistentStore() {
//        do {
//            try moc.save()
//        } catch {
//            print("Error saving: \(error)")
//        }
//    }
    
    func createEntry(title: String, body: String, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let entry = JournalEntry(title: title, bodyText: body, mood: mood, identifier: UUID().uuidString)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new entry: \(error)")
                context.reset()
            }
        }
        put(entry: entry)
    }
    
    func updateEntry(entry: JournalEntry, newTitle: String, newBody: String, newMood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard !newTitle.isEmpty else { return }
        entry.title = newTitle
        entry.bodyText = newBody
        entry.mood = newMood.stringValue
        entry.timestamp = Date()
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after updating: \(error)")
                context.reset()
            }
        }
        put(entry: entry)
    }
    
    func deleteEntry(entry: JournalEntry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: @escaping (Error?) -> Void = { _ in }) {
        deleteFromServer(entry: entry) { (error) in
            if let _ = error {
                print("Will not delete local copy")
                completion(nil)
                return
            } else {
                context.perform {
                    do {
                        context.delete(entry)
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        print("Could not save after deleting: \(error)")
                        context.reset()
                        completion(error)
                    }
                }
                completion(nil)
            }
        }
    }
    
    func update(entry: JournalEntry, with representation: JournalEntryRepresentation) {
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.title = representation.title
    }
    
    func updateEntries(with representations: [JournalEntryRepresentation]) {
        
        // Create a dictionary of Representations keyed by their UUID
          // filter out entries with no UUID
        let entriesWithID = representations.filter({ $0.identifier != nil })
          // create array of just the UUIDs (string form)
        let identifiersToFetch = entriesWithID.compactMap({ $0.identifier })
          // creates the dictionary
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationsByID   // holds all entries now, but will be whittled down
        
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        moc.perform {
            do {
                let existingEntries = try self.moc.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                    
                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                    try CoreDataStack.shared.save()
                }
                
                for representation in entriesToCreate.values {
                    let _ = JournalEntry(representation: representation)
                    try CoreDataStack.shared.save()
                }
            } catch {
                print("Error fetching tasks for UUIDs: \(error)")
            }
        }
    }
    
    // MARK: - Server methods
    
    func put(entry: JournalEntry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard var representation = entry.representation else {
            completion(nil)
            return
        }
        
        // create identifier if it doesn't exist
        let uuid = entry.identifier ?? UUID().uuidString
        // set identifier to both entry and representation in case we just created it
        entry.identifier = uuid
        representation.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            try CoreDataStack.shared.save() // if the UUID was changed, save it
            request.httpBody = try encoder.encode(representation)
        } catch {
            print("Error encoding representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error sending entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(entry: JournalEntry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(nil)
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (_, res, error) in
            if let error = error {
                print("Error deleting entry from server: \(error)")
                completion(error)
                return
            } // else {
//                print("Response: \(String(describing: res))")
//            }
            completion(nil)
        }.resume()
    }
    
    func fetchEntriesFromServer(completiom: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completiom(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data task :(")
                completiom(nil)
                return
            }
            
            var representations: [JournalEntryRepresentation] = []
            do {
                let decoder = JSONDecoder()
                let dictionaryOfEntries = try decoder.decode([String : JournalEntryRepresentation].self, from: data)
                representations = Array(dictionaryOfEntries.values)
            } catch {
                print("Error decoding entry representations: \(error)")
                completiom(error)
                return
            }
            
            self.updateEntries(with: representations)
            completiom(nil)
        }.resume()
    }
}
