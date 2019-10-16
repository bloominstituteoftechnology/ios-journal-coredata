//
//  EntryController.swift
//  Journal
//
//  Created by Isaac Lyons on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-5d828.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping () -> Error? = { () -> Error? in return nil} ) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry.")
            let _ = completion()
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry representation is nil")
            let _ = completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            let _ = completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                let _ = completion()
                return
            }
            
            let _ = completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping  () -> Error? = { () -> Error? in return nil} ) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry.")
            let _ = completion()
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error Deleting entry: \(error)")
                let _ = completion()
                return
            }
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: EntryMood, context: NSManagedObjectContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
}
