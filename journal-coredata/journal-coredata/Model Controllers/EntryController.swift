//
//  EntryController.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://journal-coredata-b58e9.firebaseio.com/")!
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    // MARK: - CRUD Methodfs
    
    func create(title: String, bodyText: String?, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(for entry: Entry, title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText ?? ""
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(at entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore() 
    }
    
    // MARK: - Firebase methods
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        
        do {
            request.httpBody = try JSONEncoder().encode(entry.entryRepresentation)
        } catch {
            NSLog("Error encoding data and assigning it to httpBody: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error initiating request after encoding data: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error with delete request for entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - Peristence Methods
    
    func saveToPersistentStore() {
        let context = CoreDataStack.shared.mainContext
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            context.reset()
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        do {
//            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching entries: \(error)")
//            return []
//        }
//    }
}
