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
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        saveToPersistence()
    }
    
    func saveToPersistence()
    {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error {
            NSLog("Failed to save to persistence: \(error)")
        }
    }
    
    func deleteEntry(on entry: Entry)
    {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistence()
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
            
            guard let data = data else { return }
            
            let responseDataString = String(data: data, encoding: .utf8)
            
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
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry?
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
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                
                for (_, entryRep) in entryRepresentations
                {
                    let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier)
                    
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
                
                self.saveToPersistence()
                completion(nil)
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}




















