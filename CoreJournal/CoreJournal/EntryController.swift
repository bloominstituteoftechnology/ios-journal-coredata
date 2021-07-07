//
//  EntryController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://core-data-journal-9ea88.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
   /* func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save() // Save the task to the persistent store.
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }*/
    
  /*  func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // We could say what kind of tasks we want fetched.
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
        
    }*/
   
  /*  var entries: [Entry] {
        return loadFromPersistentStore()
    }*/
    
    func create(withTitle title: String, andBody bodyText: String, andMood mood: String?){
        let entry = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID(), mood: EntryMood(rawValue: mood ?? "neutral")!)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating task: \(error)")
        }
        put(entry)
        
       // saveToPersistentStore()
    }
    
    func update(withEntry entry: Entry, andTitle title: String, andBody bodyText: String, andMood mood: String) {
       
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
       
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating task: \(error)")
        }
        
        put(entry)
       // saveToPersistentStore()
    }
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        

        let identifier = entry.identifier ?? UUID()
        let url = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        
        do {
            let entryJSON = try encoder.encode(entry)
            request.httpBody = entryJSON
        } catch {
            NSLog("Unable to encode task representation: \(error)")
            completion(error)
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
    
    func delete(withEntry entry: Entry) {
        deleteFromServer(entry: entry)
      
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry) // Remove from the MOC, but not the persistent store
        
        do {
            try moc.save() // Carry the removal of the task, from the MOC, to the persistent store
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        let url = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: url)
       
        request.httpMethod = "DELETE"
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(entry)
        } catch {
            print(error)
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func updateFetch(entry: Entry, entryRep: EntryRepresentation) {
        
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.identifier = UUID(uuidString: entryRep.identifier)
        entry.mood = entryRep.mood
        entry.timestamp = entryRep.timestamp
    }
    
    func fetchSingleEntryFromPersistentStore(for uuid: String, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        var entry: Entry?
        // let moc = CoreDataStack.shared.mainContext
        
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with \(uuid): \(error)")
            }
        }
        return entry
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from data entry")
                completion(NSError())
                return
            }
            
            var entries: [EntryRepresentation] = []
            
            do {
                
                let jsonDecoder = JSONDecoder()
                
                let entryRepresentations = try jsonDecoder.decode([String: EntryRepresentation].self, from: data)
                
                entries = Array(entryRepresentations.values)
                
              /*  for (_, entryRep) in entryRepresentations {
                    entries.append(entryRep)
                }*/
                let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
                
                backgroundMoc.performAndWait {
                    for entryRep in entries {
                        
                        if let entry = self.fetchSingleEntryFromPersistentStore(for: entryRep.identifier, context: backgroundMoc) {
                            if entry.identifier == UUID(uuidString: entryRep.identifier) && entry.bodyText == entryRep.bodyText && entry.mood == entryRep.mood && entry.timestamp == entryRep.timestamp && entry.title == entryRep.title {
                                
                            } else {
                                self.updateFetch(entry: entry, entryRep: entryRep)
                            }
                            
                        } else {
                            Entry(entryRepresentation: entryRep, context: backgroundMoc)
                        }
                    }
                    do {
                        try CoreDataStack.shared.save(context: backgroundMoc)
                    } catch {
                        NSLog("Error saving background context: \(error)")
                    }
                }
                completion(nil)
            } catch {
                NSLog("Error decoding EntryRepresentations: \(error)")
                completion(error)
            }
            
            }.resume()
    }
    
}
