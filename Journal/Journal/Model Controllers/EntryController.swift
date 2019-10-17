//
//  EntryController.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-a73f0.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data return from entry fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let entries = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.updateEntries(with: entries)
            } catch {
                NSLog("Error decoding EntryRepresentations: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.identifier })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var entriesToCreate = representationsByID
        
        do {
            let context = CoreDataStack.shared.mainContext
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timestamp = representation.timestamp
                entry.mood = representation.mood
                
                entriesToCreate.removeValue(forKey: identifier)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
            CoreDataStack.shared.saveToPersistentStore()
            
        } catch {
            NSLog("Error fetching entries from persistent store: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting task: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing entry: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//
//            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//            let moc = CoreDataStack.shared.mainContext
//
//            do {
//                let entries = try moc.fetch(fetchRequest)
//                return entries
//            } catch {
//                NSLog("Error fetching tasks: \(error)")
//                return []
//            }
//    }
    
    func createEntry(with title: String, bodyText: String, mood: String, context: NSManagedObjectContext) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        CoreDataStack.shared.saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        CoreDataStack.shared.saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {

        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.saveToPersistentStore()
        
    }
}
