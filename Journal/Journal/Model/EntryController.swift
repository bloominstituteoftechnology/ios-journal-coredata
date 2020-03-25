//
//  EntryController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

private let baseURL = URL(string: "https://journal-shawngee.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - CRUD
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    @discardableResult
    func createEntry(title: String, bodyText: String?, mood: Mood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        return entry
    }
    
    func update(_ entry: Entry, title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(_ entry: Entry) -> Error? {
        CoreDataStack.shared.mainContext.delete(entry)
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
    
    func sendEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
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
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
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
            
            completion(nil)
        }.resume()
    }
}
