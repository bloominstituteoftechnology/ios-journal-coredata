//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Enrique Gongora on 2/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    //MARK: - Properties
    let baseURL = URL(string: "https://journalcoredata-f0c16.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: - Initializers
    init() {
        fetchEntriesFromServer()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuidString = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuidString
            entry.identifier = uuidString
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuidString = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    //MARK: - Update Methods
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier! }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        
        // Fetch all? entries from Core Data
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                // Match the managed entries with the Firebase entries
                for entry in existingEntries {
                    guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                    self.update(entry: entry, entryRepresentation: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                // For nonmatched (new entries from Firebase) create managed objects
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                NSLog("Error fetching tasks: \(error)")
            }
        }
        // Save all this in CoreData
        try CoreDataStack.shared.save(context: context)
    }
    
    //MARK: - Fetch Entries Method
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in } ) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let entryRepresentations = Array(try jsonDecoder.decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                NSLog("Error decoding entry: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    //MARK: - CRUD Methods
    
    // Create Method
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
    }
    
    // Update Method
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
    }
    
    // Delete Method
    func deleteEntry(_ entry: Entry) {
        deleteEntryFromServer(entry: entry) { (error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                return
            }
            guard let moc = entry.managedObjectContext else { return }
            moc.perform {
                do {
                    moc.delete(entry)
                    try CoreDataStack.shared.save(context: moc)
                } catch {
                    moc.reset()
                    NSLog("Error deleting entry: \(error)")
                }
            }
        }
    }
}
