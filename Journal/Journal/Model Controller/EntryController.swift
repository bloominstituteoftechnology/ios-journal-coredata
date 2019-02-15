//
//  EntryController.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        
        do {
            
            let entryData = try jsonEncoder.encode(entry)
            urlRequest.httpBody = entryData
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        
        let jsonEncoder = JSONEncoder()
        
        do {
            
            let entryData = try jsonEncoder.encode(entry)
            urlRequest.httpBody = entryData
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let url = baseURL.appendingPathExtension("json")
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entry: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task ")
                completion(NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let entryRepresentations = try jsonDecoder.decode([String : EntryRepresentation].self, from: data).map( { $0.value } )
                
                let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
                
                self.checkEntryRepresentations(entryRepresentations: entryRepresentations, context: backgroundMoc)
                
                completion(nil)
            } catch {
                NSLog("Error decoding Entry Representation: \(error)")
                completion(error)
            }
        }
        dataTask.resume()
    }
    
    func create(title: String, bodyText: String, mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        put(entry)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating task: \(error)")
        }
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood
        
        put(entry)
    }
    
    func updateFromEntryRep(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    func fetchSingleEntryFromPersistentStore(foruuid uuid: String, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        var entry: Entry?
        
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with \(uuid): \(error)")
            }
        }
        return entry
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        deleteEntryFromServer(entry)
    }
    
    func checkEntryRepresentations(entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext) {
        
        context.performAndWait {
            for entryRep in entryRepresentations {
                
                if let entry = self.fetchSingleEntryFromPersistentStore(foruuid: entryRep.identifier, context: context) {
                    self.updateFromEntryRep(entry: entry, entryRepresentation: entryRep)
                } else {
                    _ = Entry(entryRepresentation: entryRep, context: context)
                }
            }
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context")
            }
        }
    }
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://journal-core-data-sync.firebaseio.com/")!
    
}
