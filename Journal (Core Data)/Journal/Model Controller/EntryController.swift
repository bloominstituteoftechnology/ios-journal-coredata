//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let baseURL = URL(string: "https://journalday3.firebaseio.com/")!
    
    // MARK: - CRUD
    
    func create(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        
        saveToCoreData()
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood
        
        put(entry: entry)
        
        saveToCoreData()
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)

        saveToCoreData()
    }
    
    // MARK: - DataBase
    
    typealias CompletionHandler = (Error?) -> Void
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        // Get the entry's identifier, or if it doesn't have one, create a new uuid
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = EntryController.baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = EntryController.baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error DELETing entry from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    
    // MARK: - Persistence
    
    func saveToCoreData() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving entry: \(error)")
        }
    }
}
