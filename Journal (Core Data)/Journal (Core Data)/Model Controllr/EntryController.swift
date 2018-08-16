//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 14/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-e4408.firebaseio.com/")!

class EntryController
{
    init()
    {
        fetchEntriesFromServer()
    }
    
    func updateEntry(on entry: Entry, with title: String, bodyText: String, mood: String)
    {
        let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
        
        backgroundMoc.performAndWait {
            entry.title = title
            entry.bodyText = bodyText
            entry.timestamp = Date()
            entry.mood = mood
        }
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            NSLog("Error saving update: \(error)")
        }
    }
    
    func deleteEntry(on entry: Entry)
    {
        let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
        
        deleteEntryFromServer(entry: entry)
        
        backgroundMoc.performAndWait {
            backgroundMoc.delete(entry)
        }
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            NSLog("Error saving update: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> () = {_ in })
    {
                let url = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        do {
            let data = try JSONEncoder().encode(entry)
            urlRequest.httpBody = data
        } catch {
            NSLog("Failed to encode entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Failed to upload entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> () = {_ in })
    {
        let url = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Failed to delete from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation)
    {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry?
    {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching: \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> () = {_ in })
    {
        let url = baseURL.appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Error fetching from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Failed to unwrap data")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
                try self.updateEntries(with: entryRepresentations, context: backgroundMoc)
                completion(nil)
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws
    {
        var error: Error?
        
        context.performAndWait {
            
            for entryRep in representations
            {
                let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: context)
                
                if let entry = entry
                {
                    if entry != entryRep
                    {
                        self.update(entry: entry, entryRepresentation: entryRep)
                    }
                }
                else
                {
                    let _ = Entry(entryRepresentation: entryRep)
                }
            }
            
            do {
                try CoreDataStack.shared.saveContext()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
        
    }
}




















