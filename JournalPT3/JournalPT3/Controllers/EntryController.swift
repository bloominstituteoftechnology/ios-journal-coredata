//
//  EntryController.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://journalpt3.firebaseio.com/")
    
    private let moc = CoreDataStack.shared.mainContext
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    init() {
        fetchEntriesFromServer()
    }
    
    private func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let baseURL = baseURL else { return }
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error PUTing entry to the server: \(error!)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let baseURL = baseURL else { return }
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
                completion(error)
        }.resume()
    }
    
    func createEntry(title: String, mood: EntryMood, bodyText: String?) {
        let entry = Entry(title: title, mood: mood, bodyText: bodyText)
        put(entry: entry)
        try! saveToPersistentStore()
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
        entry.bodyText = entryRepresentation.bodyText
        entry.identifier = entryRepresentation.identifier
        //put(entry: entry)
    }
    
    func updateEntry(title: String, mood: EntryMood = .normal, bodyText: String?, entry: Entry) {
        entry.title = title
        entry.mood = mood.rawValue
        entry.bodyText = bodyText
        entry.timestamp = Date()
        put(entry: entry)
        try! saveToPersistentStore()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        
        let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier!) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let existingEntries = try moc.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[UUID(uuidString: id)!] else {
                        moc.delete(entry)
                        continue
                }
                
                update(entry: entry, entryRepresentation: representation)
                    
                entriesToCreate.removeValue(forKey: UUID(uuidString: id)!)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: moc)
            }
        } catch {
            print("Error fetching entries for UUIDs: \(error)")
        }
        try saveToPersistentStore()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        guard let baseURL = baseURL else { return }
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard error == nil else {
                print("Error fetching entries from server: \(error!)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        moc.delete(entry)
        try! saveToPersistentStore()
    }
    
    private func saveToPersistentStore() throws {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
