//
//  EntryController.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://day3-journal.firebaseio.com/")!

class EntryController
{
    var entry: Entry?
    typealias CompletionHandler = (Error?) -> Void
    
    init()
    {
        fetchEntriesFromServer()
    }
    
    func saveToPersistentStore()
    {
        do
        {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            print("save")
        }
        catch
        {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, mood:EntryMood)
    {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        print(title, bodyText)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: NSDate = NSDate(), mood: EntryMood)
    {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp as Date
        entry.mood = mood.rawValue
        print(title, bodyText)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry)
    {
        let entry = entry
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        do
        {
            try moc.save()
        }
        catch
        {
            moc.reset()
        }
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in })
    {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }
            .resume()
    }
    
    func put(entry:Entry, completion: @escaping CompletionHandler = { _ in })
    {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"//to update existing task
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
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
        }
        .resume()
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation)
    {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
        entry.mood = representation.mood
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry?
    {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do
        {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        }
        catch
        {
            NSLog("Error fetching task with identifier \(error)")
            return nil
        }

    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in })
    {
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error
            {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else
            {
                NSLog("No data returned by data task")
                completion(error)
                return
            }
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                
                for (_, entryRep) in entryRepresentations {
                    
                    guard let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier) else {
                        
                        return
                        
                    }
                    
                    if entry != entryRep
                    {
                       self.update(entry: entry, with: entryRep)
                    }
                    else
                    {
                        let _ = Entry(entryRespresentation: entryRep)
                    }
                    
                }
                
                self.saveToPersistentStore()
                completion(nil)
                
            } catch {
                NSLog("Error decoding task representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
}
