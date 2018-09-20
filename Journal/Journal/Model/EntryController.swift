//
//  EntryController.swift
//  Journal
//
//  Created by Daniela Parra on 9/17/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - CRUD Methods
    
    
    func createEntry(with title: String, bodyText: String, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        
        CoreDataStack.shared.mainContext.delete(entry)
        
        saveToPersistentStore()
    }
    
    // MARK: - Core Data
    
    func saveToPersistentStore(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
       
        context.perform {
            do {
                try context.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        let moc = CoreDataStack.shared.mainContext
//
//        var entries: [Entry] = []
//
//        moc.performAndWait {
//            do {
//                entries = try moc.fetch(fetchRequest)
//            } catch {
//                NSLog("Error fetching entries: \(error)")
//            }
//        }
//        return entries
//    }
    
    // MARK: - Networking
    
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var entry: Entry? = nil
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with given identifier: \(error)")
            }
        }
        return entry
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { return }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                let resultsDictionary = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                entryRepresentations = resultsDictionary.map({  $0.value })
                
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                self.checkEntryRepresentation(entryRepresentations: entryRepresentations, context: backgroundContext)
                self.saveToPersistentStore(context: backgroundContext)
                completion(nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let identifier = entry.identifier else { return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let identifier = entry.identifier else {
            NSLog("No identifier for entry to delete.")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            print(response!)
            completion(nil)
            }.resume()
    }
    
    // MARK: - Private methods
    
    private func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    private func checkEntryRepresentation(entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            for entryRep in entryRepresentations {
                let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: context)
                
                if let entry = entry {
                    if entry != entryRep {
                        self.update(entry: entry, entryRepresentation: entryRep)
                    }
                } else {
                    _ = Entry(entryRepresentation: entryRep)
                }
            }
        }
    }

    let baseURL = URL(string: "https://daniela-core-data-journal.firebaseio.com/")!
}
