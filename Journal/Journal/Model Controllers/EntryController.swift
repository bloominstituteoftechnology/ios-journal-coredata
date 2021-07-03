//
//  EntryController.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-core-data-eed2a.firebaseio.com/")!

class EntryController {
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        self.fetchEntrysFromServer()
    }
    
    func fetchEntrysFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned by the data task"); completion(error); return }
            
            do {
                let entryReps = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                let moc = CoreDataStack.shared.mainContext
                try self.updateEntries(with: entryReps, context: moc)
                
                completion(nil)
            } catch {
                NSLog("Error decoding task representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws {
        var error: Error? = nil
        
        context.performAndWait {
            for entryRep in representations {
                let identifier = entryRep.identifier
                if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: identifier, in: context) {
                    self.update(entry: entry, with: entryRep, context: context)
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
    
    func fetchSingleEntryFromPersistentStore(forUUID uuid: String, in context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        var result: Entry? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with uuid \(uuid): \(error)")
            }
        }
        
        return result
    }
    
    func createEntry(withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        do {
            try CoreDataStack.shared.save()
            self.put(entry: entry)
        } catch {
            NSLog("Error creating entry: \(entry)")
        }
    }
    
    func updateEntry(withEntry entry: Entry, withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        
        do {
            try CoreDataStack.shared.save()
            self.put(entry: entry)
        } catch {
            NSLog("Error updating entry: \(entry)")
        }
    }
    
    // Update Entry with Entry Representation from Server
    private func update(entry: Entry, with representation: EntryRepresentation, context: NSManagedObjectContext) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
    
    func deleteEntry(withEntry entry: Entry) {
        self.deleteEntryFromServer(entry) { (error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                let moc = CoreDataStack.shared.mainContext
                moc.delete(entry)
                
                do {
                    try moc.save()
                } catch {
                    NSLog("Error saving after delete method")
                }
            }
        }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        guard var representation = entry.entryRepresentation else { completion(NSError()); return }

        do {
            representation.identifier = uuid
            entry.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
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
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            completion(error)
        }.resume()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
