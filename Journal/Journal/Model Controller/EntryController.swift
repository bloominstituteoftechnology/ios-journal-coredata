//
//  EntryController.swift
//  Journal
//
//  Created by Samantha Gatt on 8/13/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://samanthasjournalcoredata.firebaseio.com/")!
    
    // MARK: - CRUD
    
    func create(title: String, body: String?, mood: EntryMood) {
        let entry = Entry(title: title, body: body, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, body: String?, mood: EntryMood, timestamp: Date = Date()) {
        entry.title = title
        entry.body = body
        entry.mood = mood.rawValue
        entry.timestamp = timestamp
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        // Needs to delete from server first
        deleteFromServer(entry: entry)
        CoreDataStack.moc.delete(entry)
        saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.moc.save()
        }
        catch {
            NSLog("Error saving entry: \(error)")
        }
    }
    
    
    // MARK: - Networking
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        // Every entry should have an identifier since they can't be made without one so I force unwrapped it
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting task: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
