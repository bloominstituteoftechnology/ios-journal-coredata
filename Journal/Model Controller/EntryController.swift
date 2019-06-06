//
//  EntryController.swift
//  Journal
//
//  Created by Hayden Hastings on 6/3/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - Methods
    
    func saveToPersistantStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    //    func loadFromPersistantStore() -> [Entry] {
    //        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    //        let moc = CoreDataStack.shared.mainContext
    //
    //        do {
    //            return try moc.fetch(fetchRequest)
    //        } catch {
    //            NSLog("Error fetching tasks: \(error)")
    //            return []
    //        }
    //    }
    
    func create(journal title: String, bodyText: String, timestamp: Date, identifier: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
        saveToPersistantStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        saveToPersistantStore()
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        
        deleteEntryFromServer(entry: entry)
        
        if let moc = entry.managedObjectContext {
            moc.delete(entry)
            saveToPersistantStore()
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in}) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        //        var request = URLRequest(url: requestURL)
        //        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            do {
                
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                try self.updateEntries(with: entryRepresentations, context: moc)
                completion(nil)
                
                
                //                let entryRepresentationDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                //                let entryReperesentations = Array(entryRepresentationDict.values)
                //                for entryRep in entryReperesentations {
                //                    let identifier = entryRep.identifier
                //                    if let entry = self.fetchSingleEntryFromPersistentStore(identifier: identifier) {
                //                        self.update(entry: entry, with: entryRep)
                //                    } else {
                //                        let _ = Entry(entryRepresentation: entryRep)
                //                    }
                //                }
                
                //                self.saveToPersistantStore()
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
            }.resume()
        
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String, in context: NSManagedObjectContext) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: Entry? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with uuid \(identifier): \(error)")
            }
        }
        
        return result
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in }) {
        
        //        let uuid = entry.identifier ?? UUID().uuidString
        //        entry.identifier = uuid
        
        guard let uuid = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
            
            }.resume()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            
            guard var representation = entry.entryRepresentation else { completion(NSError())
                return
            }
            
            representation.identifier = uuid
            entry.identifier = uuid
            
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            
            NSLog("Error encoding entry: \(error)")
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
            }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws {
        var error: Error? = nil
        context.performAndWait {
            for entryRep in representations {
                guard let uuid = UUID(uuidString: entryRep.identifier) else { continue }
                
                if let entry = self.fetchSingleEntryFromPersistentStore(identifier: uuid.uuidString, in: context) {
                    self.update(entry: entry, with: entryRep)
                } else {
                    let _ = Entry(entryRepresentation: entryRep, context: context)
                }
            }
            
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood =  representation.mood
    }
    
    // MARK: - Properties
    
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://journal-a251f.firebaseio.com/")!
}
