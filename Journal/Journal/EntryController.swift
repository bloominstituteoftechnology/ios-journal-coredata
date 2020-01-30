//
//  EntryController.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/27/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journalgp-41898.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json") // + /json ?
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing task representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }.resume()
    }
    
    // convert to Core Data obj
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        // filter out the no ID ones
        let tasksWithID = representations.filter { $0.identifier != nil }
        
        // creates a new UUID based on the identifier of the task we're looking at (and it exists)
        // compactMap returns an array after it transforms
        let identifiersToFetch = tasksWithID.compactMap { UUID(uuidString: $0.identifier!) }
        
        // zip interweaves elements
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, tasksWithID))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                // continue skips next iteration of for loop
                guard let id = entry.identifier, let representation = representationsByID[id] else {continue}
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation)
            }
        } catch {
            print("Error fetching entries for UUIDs: \(error)")
        }
        
        self.saveToPersistentStore()
    }
    
    // updates local with data from the remote
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp // ?
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: UUID, mood: Mood) {
        // ?
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
        saveToPersistentStore()
    }
    
    func update(title: String, bodyText: String, mood: Mood, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        //print("UPDATED ENTRY: \(entry.title), \(entry.bodyText), \(entry.timestamp)")
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        print("DELETE")
        /*
        -Take an an Entry object to delete
        -Delete the Entry from the core data stack's mainContext
        -Save this deletion to the persistent store.
        */
    }
}
