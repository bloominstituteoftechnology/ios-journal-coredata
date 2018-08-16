//
//  EntryController.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation
import CoreData


let baseURL: URL = URL(string: "https://coredatajournal.firebaseio.com/")!

class EntryController {
    
    // MARK: - Type alias
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Initializer
    init() {
        fetchEntriesFromServer()
    }
    
    //MARK: - Methods
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in}) {
        
        let request = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: request) { (data, _ , error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error getting data from server")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
                
                try self.updateEntry(with: entryRepresentations, context: backgroundMoc)
                completion(nil)
                return
            } catch {
                NSLog("Error decoding task representations: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    
    func updateEntry(with representation: [EntryRepresentation], context: NSManagedObjectContext) throws {
        
        var error: Error?
        
        context.performAndWait {
            for entryRep in representation {
                guard let uuid = UUID(uuidString: entryRep.identifier) else {continue}
                let entry = self.fetchSingleEntryFromPersistentStore(forUUID: uuid, context: context)
                if let entry = entry {
                    self.update(entry: entry, entryRep: entryRep)
                } else {
                    let _ = Entry(entryRepresentation: entryRep, context: context)
                }
            }
            
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error {throw error}
        
    }
    
    func create(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    

    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, entryRep: EntryRepresentation) {
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.mood = entryRep.mood
        entry.timestamp = entryRep.timestamp
        entry.identifier = entryRep.identifier
    }
    
    
    func fetchSingleEntryFromPersistentStore(forUUID: UUID, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", forUUID as NSUUID)
        
        
        do {
//            let moc = CoreDataStack.shared.mainContext
//            return try moc.fetch(fetchRequest).first
            return try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with identifier: \(error)")
            return nil
        }
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
        
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _ , error) in
            if let error = error {
                NSLog("Error encoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"


        URLSession.shared.dataTask(with: request) { (data, _ , error) in
            if let error = error {
                NSLog("Error encoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

}

