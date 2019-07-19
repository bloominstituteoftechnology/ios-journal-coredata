//
//  EntryController.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-ef55cc.firebaseio.com/")!

class EntryController {
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
//
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntryFromServer()
    }
    
    // Fetch entry from the server
    
    func fetchEntryFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error Fetching entry: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by the data entry")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                try self.updateEntries(with: entryRepresentation, context: moc)
                
                completion(nil)
            } catch {
                NSLog("Error decoding task representation: \(error)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws {
        
            var error: Error? = nil
            
            context.performAndWait {
                for entryRep in representations {
                    guard let uuid = UUID(uuidString: entryRep.identifier) else {continue}
                    
                    let entry = self.entry(forUUID: uuid, context: context)
                    
                    if let entry = entry {
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
    
    private func entry(forUUID uuid: UUID, context: NSManagedObjectContext) -> Entry? {
        let fetchrequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        var result: Entry? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchrequest).first
            } catch {
                NSLog("Error fetching entry with uuid \(uuid): \(error)")
            }
        }
        
        return result
        
    }
    
    
    
    //PUT Request
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood = representation.mood
    
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            let entry = try moc.fetch(fetchRequest)
//            return entry
//        } catch {
//            NSLog("Error fetching data: \(error)")
//        }
//        return[]
//    }
//
//    func createEntry(title: String, bodyText: String){
//        let _ = Entry(title: title, bodyText: bodyText)
//        saveToPersistentStore()
//    }
//

//
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask (with: request) { (_, response, error) in
            print(response!)
            completion(error)
            
        }.resume()

//        let moc = CoreDataStack.shared.mainContext
//        moc.delete(entry)
//        try saveToPersistentStore()
    }
}
