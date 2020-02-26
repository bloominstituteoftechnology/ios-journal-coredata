//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
   
    
    // MARK: - Properties
    let baseURL: URL  = URL(string: "https://journal-coredata-knopp.firebaseio.com/")!
    let MC = CoreDataStack.shared.mainContext
    
    /*
     var entries: [Entry] {
        loadFromPersistentStore()
    }
    */
    

    
    // MARK: - Methods
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in }) {
        
        guard let identifier = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil  else {
                print("Error deleting entry")
                
            }
        }
       
        
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in }) {
        guard let identifier = entry.identifier else { return }
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("No entry, Entry == nil")
            completion(nil)
            return
        }
        
        do  {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(entryRepresentation)
        
        } catch {
            NSLog("Can't encode entry representation")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error fetching tasks from Firebase: \(error)")
                completion(error)
                return
            }
            completion(nil)

        }.resume()
    }
    
    func saveToPersistentStore() {
    do {
        try MC.save()
    } catch {
        NSLog("Error saving managed object context: \(error)")
        }
    }
    
    /*
     func loadFromPersistentStore() -> [Entry] {
        let fetch: NSFetchRequest<Entry> = Entry.fetchRequest()
        do{
            return try MC.fetch(fetch)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
   */
    
    // MARK: - CRUD
    
    // CREATE
    func create(title: String, mood: Mood, timeStamp: Date, identifier: String, bodyText: String) {
        let  entry = Entry(title: title, timeStamp: timeStamp, identifier: identifier, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // UPDATE
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // DELETE
    
    func delete(for entry: Entry) {
        MC.delete(entry)
        saveToPersistentStore()
    }
}

