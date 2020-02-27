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
    
    // MARK: - INITIALIZER
    
    init() {
        fetchEntriesFromServer()
    }
    
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
    func update(entry: Entry, with entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timeStamp = entryRepresentation.timeStamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    
    
    /*
 func saveToPersistentStore() {
        do {
            try MC.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    */
    
    // MARK: - SERVER METHODS
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in  }) {
        let requestURL = baseURL.appendingPathExtension("json")
               
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
                   if let error = error {
                       NSLog("Error fetching tasks from Firebase: \(error)")
                       completion(error)
                       return
                    
            }
                   
            guard let data = data else {
                NSLog("No data returned from Firebase")
                completion(NSError())
                return
            }
                   
            let jsonDecoder = JSONDecoder()
            do {
                let entryRepresenations = Array(try jsonDecoder.decode([String : EntryRepresentation].self, from: data).values)
                       try self.updateEntries(with: entryRepresenations)
                       completion(nil)
                   } catch {
                       NSLog("Error decoding task representations from Firebase: \(error)")
                       completion(error)
                   }
               }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        // Dictionary that can be mutated
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "Indentifiers IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            
        do {
                    let existingEntries = try context.fetch(fetchRequest)
                    
                    // Match the managed tasks with the Firebase tasks
                    for entry in existingEntries {
                        guard let id = entry.identifier,
                            let representation = representationsByID[id] else { continue }
                        
                        self.update(entry: entry, with: representation)
                        entriesToCreate.removeValue(forKey: id)
                    }
                    
                    // For nonmatched (new tasks from Firebase), create managed objects
                    for representation in entriesToCreate.values {
                        Entry(entryRepresentation: representation, context: context)
                    }
                    } catch {
                    NSLog("Error fetching tasks for UUIDs: \(error)")
                }
        }
        try CoreDataStack.shared.save(context: context)
        
        }
        
    
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
                print("Error deleting entry: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
                
        }.resume()
            
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
    func createEntry(title: String, mood: Mood, timeStamp: Date, identifier: String, bodyText: String) {
        let  entry = Entry(title: title, timeStamp: timeStamp, identifier: identifier, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // UPDATE
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        put(entry: entry)
        saveToPersistentStore()
    }
    
    // DELETE
    
    func deleteEntry(for entry: Entry) {
        deleteEntryFromServer(entry: entry) { (error) in
            guard error == nil else {
                print("Error deleting entry from server: \(String(describing: error))")
                return
            }
        
        
            self.MC.delete(entry)
            self.saveToPersistentStore()
        }
    }



}
