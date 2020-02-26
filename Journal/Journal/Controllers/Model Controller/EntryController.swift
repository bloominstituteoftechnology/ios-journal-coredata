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

class EntryController {
    
    let baseURL = URL(string: "https://journal-ios14.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Networking Methods
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else { return }
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("There is no entry representation")
            completion(NSError())
            return
        }
        
        do {
            let entryData = try JSONEncoder().encode(entryRepresentation)
            request.httpBody = entryData
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error storing entries in Firebase: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else { return }
        
        let requestURL = baseURL
        .appendingPathComponent(identifier)
        .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - Core Data Methods
    
    func saveToPersistentStore() {
        do {
            try CoreDataTask.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataTask.shared.mainContext.reset()
        }
    }
    
    @discardableResult
    func createEntry(called title: String, bodyText: String, timeStamp: Date, identifier: String, mood: Mood) -> Entry {
        
        let entry = Entry(title: title,
                          bodyText: bodyText,
                          timeStamp: timeStamp,
                          identifier: identifier,
                          mood: mood,
                          context: CoreDataTask.shared.mainContext)
        put(entry: entry)
        saveToPersistentStore()
        return entry
    }
    
    func update(entry: Entry, called title: String, bodyText: String, timeStamp: Date, identifier: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = timeStamp
        entry.identifier = identifier
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
