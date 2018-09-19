//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Moin Uddin on 9/17/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        }
        catch {
            NSLog("Error fetching: \(error)")
            return []
        }
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
           try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
    }
    
        typealias CompletionHandler = (Error?) -> Void
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in } ) {
        guard let identifier = entry.identifier else { return }
        var requestURL = baseUrl.appendingPathComponent(identifier)
        requestURL.appendPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                NSLog("There was an error with the PUT Request: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
        
    }
    
    let baseUrl = URL(string: "https://moinjournal.firebaseio.com/")!

}
