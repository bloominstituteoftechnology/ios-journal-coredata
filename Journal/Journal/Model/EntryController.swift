//
//  EntryController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://journal-b6258.firebaseio.com/")!
    
    let formatter = DateFormatter()
    
    func createEntry(title: String, bodyText: String? = nil, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
        
        let currentDateTime = Date()
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = currentDateTime
        entry.mood = mood.rawValue
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            deleteEntryFromServer(entry)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            var representation = entry.entryRepresentation
            
            representation.identifier = uuid
            entry.identifier = uuid
            do {
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error saving context: \(error)")
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(error)
            return
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
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(error)
                return }
        
                do {
                    let entryReps = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                    let backGroundContext = CoreDataStack.shared.container.newBackgroundContext()
                    
                    try self.updateEntries(with: entryReps, context: backGroundContext)
                    completion(nil)
                    
                } catch {
                    NSLog("Error decoding task representations: \(error)")
                    completion(nil)
                    return
                }
            }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) throws {

        var error: Error? = nil
        
        context.performAndWait {
            for entryRep in representations {
                guard let uuid = UUID(uuidString: entryRep.identifier!) else {continue}
                
                let entry = self.entry(for: uuid, context: context)
                
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
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timeStamp = representation.timeStamp
        entry.identifier = representation.identifier
    }
    
    func fetchSingleEntryFromStore(UUID uuid: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with uuid \(uuid): \(error)")
            return nil
        }
    }
    
    
    private func entry(for uuid: UUID, context: NSManagedObjectContext) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        fetchRequest.predicate = predicate
        
        var result: Entry? = nil
        context.performAndWait {
            
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with UUID: \(uuid): \(error)")
            
        }
        }
        return result
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
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
    
    
//    func saveToPersistentStore() {
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            try moc.save()
//        }
//        catch {
//            NSLog("Error saving MOC: \(error)")
//            moc.reset()
//        }
//
//    }
    
    
    
}

