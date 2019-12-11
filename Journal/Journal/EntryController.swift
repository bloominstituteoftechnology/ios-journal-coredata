//
//  EntryController.swift
//  Journal
//
//  Created by Craig Swanson on 12/4/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    private let baseURL = URL(string: "https://journal-9147c.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = {_ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard error == nil else {
                print("Error fetching tasks: \(error!)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                completion(NSError())
                return
            }
            
            do {
            var entries: [EntryRepresentation] = []
            entries = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
            
            try self.updateEntries(with: entries)
            
            completion(nil)
            } catch {
                print("Error decoding entries: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    // create and update are passed an "Entry" object, so all I need to do here is save.  I wasn't sure what a better way might be while still having the createEntry and updateEntry methods here, as we were instructed to do.
    func createEntry(for entry: Entry) {
        put(entry: entry)
        saveToPersistentStore()
    }
    func updateEntry(for entry: Entry) {
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // deleteEntry is passed an entry object, deletes it from the array and saves the results.
    func deleteEntry(for entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry)
        saveToPersistentStore()
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let identifier = entry.identifier else { return }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                print("Error creating EntryRepresentation in PUT")
                completion(nil)
                return
            }
            
            representation.identifier = identifier
            entry.identifier = identifier
            saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error PUTing task to server: \(error!)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier }
        
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try moc.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationByID[id] else {
                        let moc = CoreDataStack.shared.mainContext
                        moc.delete(entry)
                        continue
                }
                
                update(entry: entry, representation: representation)
                
                entriesToCreate.removeValue(forKey: id)
                // at the completion of this loop above, the remaining entries in entriesToCreate are ones that existed in the server but not in core data.
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: moc)
            }
        } catch {
            print("Error fetching tasks for identifiers: \(error)")
        }
        saveToPersistentStore()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let identifier = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                print("Error deleting task: \(error!)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    private func update(entry: Entry, representation: EntryRepresentation) {
        entry.bodyText = representation.bodyText
        entry.identifier = representation.identifier
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.title = representation.title
    }
}
