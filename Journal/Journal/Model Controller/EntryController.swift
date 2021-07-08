//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-coredata-ss.firebaseio.com/")!

class EntryController {
    
    // MARK: - INIT
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - Functions
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data entry")
                completion(NSError())
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            do {
                let decodedEntries = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                entryRepresentations = Array(decodedEntries.values)
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding task representation: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error putting entry to server \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    private func updateEntries(with representation: [EntryRepresentation]) throws {
        let entriesWithId = representation.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithId.compactMap { UUID(uuidString: $0.identifier!) }
        
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithId))
        
        var entriesToCreate = representationByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationByID[id] else { continue }
                
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
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            if let error = error {
                print("Error deleting entry to server \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    // MARK: CRUD Methods
    
    func create(title: String, timestamp: Date, mood: String, bodyText: String?) {
        let entry = Entry(title: title, timestamp: timestamp, mood: mood, bodyText: bodyText)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
    
    func update(for entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(for entry: Entry) {
        deleteEntryFromServer(entry)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}
