//
//  EntryController.swift
//  Journal
//
//  Created by Hayden Hastings on 6/3/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Methods
    
    func saveToPersistantStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
//    func loadFromPersistantStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching tasks: \(error)")
//            return []
//        }
//    }
    
    func create(journal title: String, bodyText: String, timestamp: Date, identifier: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
        saveToPersistantStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        saveToPersistantStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        if let moc = entry.managedObjectContext {
            moc.delete(entry)
            saveToPersistantStore()
        }
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        
        guard let requestURL = baseURL?.appendingPathComponent(uuid).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETEing task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        
        guard let requestURL = baseURL?.appendingPathComponent(uuid).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            
            guard let representation = entry.entryRepresentation else { throw NSError() }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - Properties
    
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://journal-a251f.firebaseio.com/")
}
