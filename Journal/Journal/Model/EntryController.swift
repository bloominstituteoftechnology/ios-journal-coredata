//
//  EntryController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Init
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - CRUD
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    @discardableResult
    func createEntry(title: String, bodyText: String?, mood: Mood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        sendEntryToServer(entry)
        saveToPersistentStore()
        return entry
    }
    
    func update(_ entry: Entry, title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        sendEntryToServer(entry)
        saveToPersistentStore()
    }
    
    func delete(_ entry: Entry) -> Error? {
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry)
        return saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    private func loadFromPersistentStore() -> [Entry] {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(request)
            return entries
        } catch {
            NSLog("Error fetching Entry objects from main context: \(error)")
            return []
        }
    }
    
    @discardableResult
    private func saveToPersistentStore() -> Error? {
        do {
            try CoreDataStack.shared.mainContext.save()
            return nil
        } catch {
            NSLog("Error saving core data main context: \(error)")
            return error
        }
    }
    
    
    // MARK: - Networking
    
    typealias CompletionHandler = (Error?) -> Void
    typealias IDString = String
    
    private let baseURL = URL(string: "https://journal-shawngee.firebaseio.com/")!
    
    private func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching entries \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                NSLog("Invalid Response: \(response)")
                completion(NSError(domain: "Invalid Response", code: response.statusCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let entryRepresentations = try decoder.decode([IDString: EntryRepresentation].self, from: data)
                try self.updateEntries(representationsByID: entryRepresentations)
                completion(nil)
            } catch {
                NSLog("Couldn't update entries \(error)")
                completion(error)
            }
        }.resume()
    }
    
    private func sendEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry.representation)
        } catch {
            NSLog("Error encoding JSON representation of entry: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                NSLog("Invalid Response: \(response)")
                completion(NSError(domain: "Invalid Response", code: response.statusCode))
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    private func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                NSLog("Invalid Response: \(response)")
                completion(NSError(domain: "Invalid Response", code: response.statusCode))
                return
            }

            completion(nil)
        }.resume()
    }
    
    private func updateEntries(representationsByID: [IDString: EntryRepresentation]) throws {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", Array(representationsByID.keys))
        let context = CoreDataStack.shared.mainContext
        
        let existingEntries = try context.fetch(fetchRequest)
        var entriesToCreate = representationsByID
        
        for entry in existingEntries {
            let id = entry.identifier
            guard let representation = representationsByID[id] else { continue }
            update(entry, with: representation)
            entriesToCreate.removeValue(forKey: id)
        }
        
        for representation in entriesToCreate.values {
            Entry(representation)
        }
        
        saveToPersistentStore()
    }
    
    private func update(_ entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.moodString = representation.moodString
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
}
