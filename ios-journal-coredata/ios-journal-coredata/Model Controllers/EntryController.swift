//
//  EntryController.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

let baseURL: URL = URL(string: "https://stefanojournal.firebaseio.com/")!

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    enum HTTPMethods: String {
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    func create(title: String, bodyText: String, mood: String, context: NSManagedObjectContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        context.performAndWait {
            do {
                try saveToPersistenceStore(context: context)
            } catch {
                NSLog("Error creating data in persistence store: \(error)")
            }
        }
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String, context: NSManagedObjectContext) {
        context.performAndWait {
            entry.title = title
            entry.bodyText = bodyText
            entry.mood = mood
            entry.timestamp = Date()
        }
        put(entry: entry)
        do {
            try saveToPersistenceStore(context: context)
        } catch {
            NSLog("Error updating data in persistence store: \(error)")
        }
        
    }

    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        
        let moc = CoreDataStack.shared.mainContext
        
        moc.performAndWait {
            moc.delete(entry)
            do {
                try moc.save()
            } catch {
                NSLog("Error deleting data from persistence store: \(error)")
            }
        }

    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(error)
                return
            }
            
            
            do {
                let entryRepresentations = try Array(JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                try self.refreshPersistenceStore(with: entryRepresentations, context: moc)
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func refreshPersistenceStore(with entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext) throws {
        var error: Error?
        
        context.performAndWait {
            for entryRep in entryRepresentations {
                if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: entryRep.identifier, context: context) {
                    if entry == entryRep {
                        self.update(entry: entry, entryRepresentation: entryRep, context: context)
                    }
                } else {
                    let _ = Entry(entryRepresentation: entryRep, context: context)
                }
            }
        }
        
        do {
            try self.saveToPersistenceStore(context: context)
        } catch let updateError {
            NSLog("Error updating entry: \(updateError)")
            error = updateError
        }
        
        if let error = error { throw error }
        
    }
    
    // We provide the function with a default value of an empty closure
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("Could not get entry identifier for: \(entry)")
            completion(NSError())
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put.rawValue
        
        do {
            let jsonEntry = try JSONEncoder().encode(entry)
            request.httpBody = jsonEntry
        } catch {
            NSLog("Error encoding data: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("Could not get entry identifier for: \(entry)")
            completion(NSError())
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func saveToPersistenceStore(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                NSLog("Error saving data from persistence store: \(saveError)")
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    private func update(entry: Entry, entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        context.performAndWait {
            entry.title = entryRepresentation.title
            entry.bodyText = entryRepresentation.bodyText
            entry.mood = entryRepresentation.mood
            entry.identifier = entryRepresentation.identifier
            entry.timestamp = entryRepresentation.timestamp
        }
    }
    
    private func fetchSingleEntryFromPersistentStore(forUUID uuid: String, context: NSManagedObjectContext) -> Entry? {
        var entry: Entry?
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error saving data from persistence store: \(error)")
            }
        }
        
        if let entry = entry { return entry } else { return nil }
    }
    
}
