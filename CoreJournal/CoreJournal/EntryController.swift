//
//  EntryController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://core-data-journal-9ea88.firebaseio.com/")!
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save() // Save the task to the persistent store.
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
  /*  func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // We could say what kind of tasks we want fetched.
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
        
    }*/
   
  /*  var entries: [Entry] {
        return loadFromPersistentStore()
    }*/
    
    func create(withTitle title: String, andBody bodyText: String, andMood mood: String?){
        let entry = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID(), mood: EntryMood(rawValue: mood ?? "neutral")!)
        put(entry)
        saveToPersistentStore()
    }
    
    func update(withEntry entry: Entry, andTitle title: String, andBody bodyText: String, andMood mood: String) {
       
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        
        put(entry)
        saveToPersistentStore()
    }
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        // Create a URLRequest
        let identifier = entry.identifier ?? UUID()
        let url = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        
        // Task -> TaskRepresentation -> JSON Data
        
     /*   guard let entry = entry else {
            NSLog("Unable to convert task to task representation")
            completion(NSError())
            return
        }*/
        
        let encoder = JSONEncoder()
        
        do {
            let entryJSON = try encoder.encode(entry)
            request.httpBody = entryJSON
        } catch {
            NSLog("Unable to encode task representation: \(error)")
            completion(error)
        }
        
        // Create a URLSessionDataTask
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
    
    func delete(withEntry entry: Entry) {
        deleteFromServer(entry: entry)
      
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry) // Remove from the MOC, but not the persistent store
        
        do {
            try moc.save() // Carry the removal of the task, from the MOC, to the persistent store
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        let url = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: url)
       
        request.httpMethod = "DELETE"
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(entry)
        } catch {
            print(error)
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
}
