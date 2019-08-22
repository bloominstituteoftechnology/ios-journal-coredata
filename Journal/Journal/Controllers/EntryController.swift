//
//  EntryController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case badData
    case noDecode
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-5ee58.firebaseio.com/")!
    
    // Create
    func createEntry(with title: String, bodyText: String, timeStamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood)
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new task :\(error)")
            }
            put(entry: entry)
        }
    }
    
    // Update
    func updateEntry(entry: Entry, with title: String, bodyText: String, timeStamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            entry.title = title
            entry.bodyText = bodyText
            entry.timeStamp = timeStamp
            entry.mood = mood.rawValue
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when updating entry:\(error)")
            }
            
            put(entry: entry)
        }
    }
    
    // Delete
    func deleteEntry(entry: Entry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        deleteEntryFromServer(entry: entry)
        context.performAndWait {
            context.delete(entry)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when deleting entry:\(error)")
            }
        }
    }
    
    func update(entry: Entry, with entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.timeStamp = entryRepresentation.timeStamp
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
        entry.bodyText = entryRepresentation.bodyText
    }
}

// MARK: - Extensions

extension EntryController {
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        guard let identifier = entry.identifier else { return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            let entryData = try JSONEncoder().encode(entry.entryRepresentation)
            request.httpBody = entryData
        } catch {
            NSLog("Error encoding entry representation:\(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTing entryRep to server:\(error)")
            }
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping(NetworkError?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.noAuth)
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry:\(error)")
            }
            completion(nil)
        }.resume()
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        var entry: Entry? = nil
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with identifier \(identifier):\(error)")
                entry = nil
            }
        }
        return entry
    }
    
    func fetchEntriesFromServer(completion: @escaping() -> Void) {
        
        let requestURL     = baseURL.appendingPathExtension("json")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries from server:\(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Error GETing data from all entries")
                completion()
                return
            }
            
            do {
                let entriesDictionary = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let entryRepArray = entriesDictionary.map({ $0.value })
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                
                self.updatePersistentStore(forTasksIn: entryRepArray, for: moc)
                
            } catch {
                NSLog("error decoding entries:\(error)")
            }
            completion()
        }.resume()
    }
    
    func updatePersistentStore(forTasksIn entryRepresentations: [EntryRepresentation], for context: NSManagedObjectContext) {
        context.performAndWait {
            for entryRep in entryRepresentations {
                guard let identifier = entryRep.identifier else { continue }
                if let entry = self.fetchSingleEntryFromPersistentStore(identifier: identifier, context: context) {
                    entry.title = entryRep.title
                    entry.timeStamp = entryRep.timeStamp
                    entry.mood = entryRep.mood
                    entry.identifier = entryRep.identifier
                    entry.bodyText = entryRep.bodyText
                } else {
                    Entry(entryRepresentation: entryRep)
                }
            }
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
    
}
