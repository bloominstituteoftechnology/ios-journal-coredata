//
//  EntryController.swift
//  Journal
//
//  Created by Sean Hendrix on 11/5/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-af2c7.firebaseio.com/")

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntrysFromServer()
    }
    
    func saveToPersistenceStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Could not save to disk: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    
    //    func newEntry(title: String, bodyText: String, mood: String) {
    //        _ = Entry(title: title, bodyText: bodyText, mood: mood)
    //        saveToPersistenceStore()
    //    }
    
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey: "bodyText")
        entry.setValue(Date(), forKey: "timestamp")
        entry.setValue(mood, forKey: "mood")
        
        saveToPersistenceStore()
    }
    
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistenceStore()
    }
    
    
    func fetchEntrysFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL!.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data returned from data entry.")
                completion(NSError())
                return
            }
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            do {
                let entryRepresentationsDict = try JSONDecoder().decode([String : EntryRepresentation].self, from: data)
                let entryRepresentations = Array(entryRepresentationsDict.values)
                
                for entryRep in entryRepresentations {
                    let uuid = entryRep.identifier
                    
                    if let entry = self.entry(for: uuid, in: moc) {
                        guard let mood = Moods(rawValue: entryRep.mood) else { return }
                        self.update(entry: entry, with: entryRep.title, bodyText: entryRep.bodyText, mood: mood)
                    } else {
                        moc.perform {
                            let _ = Entry(entryRepresentation: entryRep, context: moc)
                        }
                    }
                }
                try CoreDataStack.shared.save(context: moc)
                
            } catch {
                NSLog("Error decoding Entry representations: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let identifer = entry.identifier ?? UUID()
        
        let requestURL = baseURL!.appendingPathComponent(identifer.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var entryRepresentation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            entryRepresentation.identifier = identifer.uuidString
            entry.identifier = identifer
            
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
            
        } catch {
            NSLog("Error encoding Entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing Entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
            }.resume()
        
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL!.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { ( _, _, error) in
            completion(error)
            }.resume()
    }
    
    func createEntry(with title: String, bodyText: String?, mood: Moods, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving entry: \(error)")
        }
        put(entry: entry)
    }
    
    func update(entry: Entry, with title: String, bodyText: String?, mood: Moods) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        
        put(entry: entry)
    }
    
    func entry(for identifier: String, in context: NSManagedObjectContext) -> Entry? {
        guard let identifier = UUID(uuidString: identifier) else { return nil }
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        fetchRequest.predicate = predicate
        
        var result: Entry? = nil
        
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with UUID: \(identifier): \(error)")
            }
        }
        
        return result
    }
    

    
}
