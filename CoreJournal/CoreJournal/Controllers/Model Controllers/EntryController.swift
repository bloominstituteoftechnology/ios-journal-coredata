//
//  EntryController.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/28/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://journal-ios-336c8.firebaseio.com/")!
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching request: \(error)")
            return []
        }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
    }
    
    // MARK: - CRUD
    func createEntry(title: String, bodyText: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: Mood(rawValue: mood) ?? .neutral)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, with rep: EntryRep) {
        entry.title = rep.title
        entry.bodyText = rep.bodyText
        entry.timestamp = rep.timestamp
        entry.mood = rep.mood
    }
    
    private func updateEntries(with rep: [EntryRep]) throws {
        let entryWithID = rep.filter { $0.identifier != nil}
        let identifiersToFetch = entryWithID.compactMap { $0.identifier }
        let repByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entryWithID))
        var entriesToCreate = repByID

        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        let context = CoreDataStack.shared.mainContext

        do {
            let existingEntries = try context.fetch(fetchRequest)

            for entry in existingEntries {
                guard
                    let id = entry.identifier,
                    let rep = repByID[id]
                    else { continue }
                self.update(entry: entry, with: rep)
                entriesToCreate.removeValue(forKey: id)
            }

            for rep in entriesToCreate.values {
                Entry(entryRep: rep)
            }
        } catch {
            NSLog("Error fetching tacks for UUIDs: \(error)")
        }
        self.saveToPersistentStore()
    }

    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }

            guard let data = data else {
                NSLog("No data returned by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }

            do {
                let entryReps = Array(try JSONDecoder().decode([String : EntryRep].self, from: data).values)
                try self.updateEntries(with: entryReps)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                NSLog("Error decoding or storing entry representaions: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }

    func updateEntry(for entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
//        put(entry: entry)
    }

    func deleteEntry(for entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
        deleteEntryFromServer(entry: entry)
    }
}
