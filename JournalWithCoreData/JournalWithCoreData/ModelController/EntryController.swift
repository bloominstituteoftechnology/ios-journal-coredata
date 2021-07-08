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
    
    func saveToPersistentStore() throws
    {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
    func createEntry(title: String, bodyText: String, mood:EntryMood)
    {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        print(title, bodyText)
        //saveToPersistentStore()
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
        //saveToPersistentStore()
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
    
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry?
    {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        var result: Entry? = nil
        do
        {
            result = try context.fetch(fetchRequest).first
            //let moc = CoreDataStack.shared.mainContext
            //return try moc.fetch(fetchRequest).first
        }
        catch
        {
            NSLog("Error fetching task with identifier \(error)")
            return nil
        }
        return result
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in })
    {
        let requestURL = baseURL.appendingPathExtension("json")
        
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
            
            do
            {
                let entryReps = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
                
                try self.updateEntries(with: entryReps, context: backgroundMoc)
                
                completion(nil)
            }
            catch
            {
                NSLog("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws
    {
        var error: Error?
        
        context.performAndWait {
            
            for entryRep in representations {
                
                guard let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: context) else {
                    let _ = Entry(entryRespresentation: entryRep, context: context)
                    continue
                    
                }
                
                if entry == entry
                {
                    self.update(entry: entry, with: entryRep)
                }
                
            }
            
            do
            {
                try context.save()
            }
            catch let saveError
            {
                error = saveError
            }
        }
        if let error = error {throw error}
    }
    
    
    
    
    
    
    
    
}
