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
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    //MARK: - Functions
    
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
            saveToPersistentStore()
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
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier! }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            for entry in existingEntries {
                guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                self.update(entry: entry, entryRepresentation: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            NSLog("Error fetching entries: \(error)")
        }
        saveToPersistentStore()
    }
    
    //MARK: - CRUD Methods
    
    // Create Method
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // Update Method
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // Delete Method
    func deleteEntry(_ entry: Entry) {
        deleteEntryFromServer(entry: entry) { (error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                return
            }
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            self.saveToPersistentStore()
        }
    }
    
    
}
