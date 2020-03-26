//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    let baseURL: URL = URL(string: "https://journal-6ef05.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> Void

    // MARK: - Methods
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        let fetchRequest = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var urlRequest = URLRequest(url: fetchRequest)
        urlRequest.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = identifier.uuidString
            entry.identifier = identifier
            try CoreDataStack.shared.mainContext.save()
            urlRequest.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error saving context or encoding entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            if let error = error {
                NSLog("Error sending (PUT) task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func delete(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        let fetchRequest = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var urlRequest = URLRequest(url: fetchRequest)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            if let error = error {
                NSLog("Error deleting (DELETE) task from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // MARK: - Persistent Store
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving managed object context (saving to persistent store): \(error)")
        }
    }
    
    // MARK: - CRUD
    func createEntry(title: String,
                     bodyText: String,
                     timestamp: Date,
                     mood: String,
                     context: NSManagedObjectContext) {
        let newEntry = Entry(title: title,
                             bodyText: bodyText,
                             timestamp: timestamp,
                             mood: mood,
                             context: CoreDataStack.shared.mainContext)
        context.insert(newEntry)
        saveToPersistentStore()
        put(entry: newEntry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        let context = CoreDataStack.shared.mainContext
        let identifier = entry.identifier ?? UUID()
        let newEntry = Entry(identifier: identifier, title: title, bodyText: bodyText, timestamp: Date(), mood: mood, context: context)
        context.delete(entry)
        context.insert(newEntry)
        saveToPersistentStore()
        put(entry: newEntry)
    }
    
    func deleteEntry(entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        delete(entry: entry)
        context.delete(entry)
        saveToPersistentStore()
    }
}

