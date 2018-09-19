//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Dillon McElhinney on 9/17/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://core-data-journal.firebaseio.com/")!
    
    // MARK: - CRUD Methods
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
        put(entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        
        saveToPersistentStore()
        put(entry)
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry)
        
        CoreDataStack.shared.mainContext.delete(entry)
        
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context to persistent store: \(error)")
        }
    }
    
    // MARK: - Networking
    
    private func put(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        
        entry.identifier = identifier
        saveToPersistentStore()
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    private func deleteEntryFromServer (_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier to delete enty by.")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETEing entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            return
        }.resume()
        
    }
}
