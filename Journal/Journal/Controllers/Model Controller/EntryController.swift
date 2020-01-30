//
//  EntryController.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

let baseURL = URL(string: "https://journal-50083.firebaseio.com/")!

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in })  {
        guard let identifier = entry.identifier else { return }
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry representation is nil")
            completion(nil)
            return
        }
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error putting entry: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if response != nil {
                NSLog("No response from Firebase")
                completion(error)
                return
            }
            
            if let error = error {
                NSLog("Error deleting entry \(entry): \(error)")
                completion(error)
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let identifiersToFetch = representations.compactMap({ $0.identifier })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let context = CoreDataTask.shared.mainContext
        
        do {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else { return }
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timeStamp = representation.timeStamp
                entry.mood = representation.mood
                
                entriesToCreate.removeValue(forKey: identifier)
                
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
                saveToPersistentStore()
            }
        } catch {
            NSLog("Error fetching entries from persistent stores: \(error)")
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                NSLog("No data return from data task")
                completion(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let taskRepresentations = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.updateEntries(with: taskRepresentations)
                DispatchQueue.main.async {
                    completion(error)
                }
            } catch {
                NSLog("Error decoding or storing entry representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            completion(nil)
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataTask.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataTask.shared.mainContext.reset()
        }
    }
    
    @discardableResult func createEntry(called title: String, bodyText: String, timeStamp: Date, mood: Mood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, context: CoreDataTask.shared.mainContext)
        put(entry: entry)
        saveToPersistentStore()
        return entry
    }
    
    func update(entry: Entry, called title: String, bodyText: String, timeStamp: Date, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = timeStamp
        entry.mood = mood
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataTask.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
}
