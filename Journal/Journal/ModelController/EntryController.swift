//
//  EntryController.swift
//  Journal
//
//  Created by Bradley Yin on 8/19/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://journal-6ccdd.firebaseio.com/")!
    
    init() {
        fetchFromServer()
    }

    func createEntry(with title: String, timeStamp: Date, bodyText: String, mood: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving to persistent when creating:\(error)")
                context.reset()
            }
            put(entry: entry)
        }
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, mood: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            entry.title = title
            entry.bodyText = bodyText
            entry.mood = mood
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving to persistent when updating:\(error)")
                context.reset()
            }
            put(entry: entry)
        }
    }
    
    func deleteEntry(entry: Entry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            deleteEntryFromServer(entry: entry)
            CoreDataStack.shared.mainContext.delete(entry)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving to persistent when deleting:\(error)")
                context.reset()
            }
        }
    }
}

extension EntryController {
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        let identifier = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            let data = try JSONEncoder().encode(entry.entryRepresentation)
            request.httpBody = data
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing entry to Firebase: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let identifier = entry.identifier else {
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETEing from firebase: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func fetchFromServer (completion: @escaping (Error?) -> Void = {_ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries from Firebase: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                return
            }
            
            do {
                let entriesRepDictionary = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let entriesRep = entriesRepDictionary.map({$0.value})
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                moc.performAndWait {
                    self.fetchSingelEntry(in: entriesRep, context: moc)
                }
            } catch {
                NSLog("Error decoding: \(error)")
            }
            completion(nil)
        }.resume()
    }
    
    func fetchSingelEntry(in entriesRep: [EntryRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for entryRep in entriesRep {
                guard let identifier = entryRep.identifier else { continue }
                
                
                if let entry = self.fetchSingleEntryFromPersistentStore(identifier: identifier, context: context) {
                    //entry exist, check if the same
                    if entry != entryRep {
                        // not the same, update
                        self.update(entry: entry, entryRep: entryRep)
                    }
                } else {
                    //entry does not exist, create one
                    Entry(entryRepresentation: entryRep, context: context)
                }
            }
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving when fetching from server: \(error)")
                context.reset()
            }
        }
    }
    func update(entry:Entry, entryRep: EntryRepresentation) {
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.mood = entryRep.mood!
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: UUID, context: NSManagedObjectContext) -> Entry? {
        let predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
    
        return try? context.fetch(fetchRequest).first
    }
}
