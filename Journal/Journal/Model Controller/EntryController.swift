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
    
    func create(name: String, body: String, mood: String?) {
        if let mood = mood {
            let entry = Entry(name: name, bodyText: body, mood: mood)
            saveToPersistentStore()
            put(entry: entry)
        } else {
            let entry = Entry(name: name, bodyText: body)
            saveToPersistentStore()
            put(entry: entry)
        }
    }
    
    func update(name: String, body: String, mood: String, entry: Entry) {
        entry.name = name
        entry.bodyText = body
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("There was an error saving delete to persistent store: \(error)")
        }
        deleteEntryFromServer(entry: entry)
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let id = entry.identifier ?? UUID().uuidString
        
        let jsonURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
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
            
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            do {
//                let decodedData = try decoder.decode([String: Entry].self, from: data)
//                
//            } catch {
//                completion(error)
//                return
//            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        
        guard let id = entry.identifier else {
            NSLog("Entry missing identifier.")
            completion(nil)
            return
        }
        
        let jsonURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: jsonURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting data from server: \(error)")
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
