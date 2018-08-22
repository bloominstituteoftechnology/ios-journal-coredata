//
//  EntryController.swift
//  Journal - Core Data
//
//  Created by Lisa Sampson on 8/20/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    let baseURL = URL(string: "https://journal-core-data.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        guard let identifier = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        }
        catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        guard let identifier = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing entry fromserver: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        
//        do {
//            return try moc.fetch(fetchRequest)
//        }
//        catch {
//            NSLog("There was an error while trying to get your entry array.")
//            return []
//        }
//    }
    
    func create(title: String, bodyText: String, mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood = .neutral) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        moc.delete(entry)
        saveToPersistentStore()
    }
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
}
