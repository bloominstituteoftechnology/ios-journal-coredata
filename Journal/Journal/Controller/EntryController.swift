//
//  EntryController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-6874f.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid
            try CoreDataStack.shared.mainContext.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding/saving task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTting task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier!
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid
            try CoreDataStack.shared.mainContext.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding/saving task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTting task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
    
    func create(title: String, bodyText: String, mood: FaceValue) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: Date(), mood: mood, context: CoreDataStack.shared.mainContext)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: FaceValue) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood.rawValue
        put(entry: entry)
        saveToPersistentStore()
    }
    
    
//    func loadFromPersistentStore() -> [Entry] {
//        var allEntries: [Entry] = []
//        let fetchRequest =
//          NSFetchRequest<NSManagedObject>(entityName: "Entry")
//
//        do {
//            allEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest) as! [Entry]
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        return allEntries
//    }
    
}
