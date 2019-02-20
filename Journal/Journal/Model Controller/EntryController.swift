//
//  EntryController.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    let baseURL = URL(string: "https://lambda-journal.firebaseio.com/")!
    
    func create(name: String, body: String) {
        _ = Entry(name: name, bodyText: body)
        saveToPersistentStore()
    }
    
    func update(name: String, body: String, mood: String, entry: Entry) {
        entry.name = name
        entry.bodyText = body
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("There was an error saving delete to persistent store: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let jsonURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: jsonURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(entry)
        } catch {
            NSLog("Problem encoding data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("There was an error saving to persistent store: \(error)")
        }
    }
    
}
