//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Initializer
    
    init(){
        fetchEntriesFromServer()
    }
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://journal-coredata-b5a96.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> Void
    
    
    
    // MARK: - CRUD functions
    
    // MARK: Create model instance
    
    func createEntry(title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving entry: \(error)")
        }
        
        put(entry: entry)
    }
    
    //MARK: Update model instance
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error updating entry: \(error)")
        }
        
        put(entry: entry)
    }
    
    // MARK: Delete model instance
    
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        let moc = CoreDataStack.shared.mainContext
        
        do {
            moc.delete(entry)
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error deleting entry: \(error)")
        }
    }
}


extension EntryController {

    // MARK: - Server

    // MARK: Put to server
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = entry.identifier else {completion(NSError()); return}
        
        let url = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            let entryData = try JSONEncoder().encode(entry)
            request.httpBody = entryData
            completion(nil)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry data to the server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // MARK: Delete from server
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = entry.identifier else {completion(NSError()); return}
        let url = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting the entry from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}


extension EntryController {
    
    // MARK: Update entry values from EntryRepresentation
    
    func update(entry: Entry, entryRepresentation er: EntryRespresentation) {
        entry.title = er.title
        entry.bodyText = er.bodyText
        entry.mood = er.mood
        entry.timestamp = er.timestamp
        entry.identifier = er.identifier
    }
    
    // MARK: Fetch single entry from Persistent Store
    
    func fetchSingleEntryFromPersistentStore(identifier id: String, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        fetchRequest.predicate = predicate
        
        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching single entry: \(error)")
            return nil
        }
    }
    
    // MARK: Fetch from Server
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching erntries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(error)
                return
            }
            
            // Get all Entry datas from server and turn them into EntryRepresentations array
            var entryRepresentations = [EntryRespresentation]()
            do {
                entryRepresentations = try JSONDecoder().decode([String:EntryRespresentation].self, from: data).map { $0.value }
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            
            func compareEntryToEntryRepresentation(context: NSManagedObjectContext) {
                // Get every single Entry from server and compare them to EntryRepresentations array
                    for entryRepresentation in entryRepresentations {
                
                    // Fetch Entry from server that has same identifier
                    let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRepresentation.identifier, context: context)
                    
                    // If Entry is not nil and not equal to the EntryRespresentation
                    if let entry = entry, entry != entryRepresentation {
                        self.update(entry: entry, entryRepresentation: entryRepresentation)
                    } else if entry == nil {
                        _ = Entry(entryRepresentation: entryRepresentation, context: context)
                    }
                }
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    NSLog("Error comparing entry to entryRepresentation: \(error)")
                }
            }
            completion(nil)
        }.resume()
    }
    
}
