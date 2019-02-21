//
//  EntryController.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    let baseURL = URL(string: "https://lambda-journal.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
    func create(name: String, body: String, mood: String?) {
        if let mood = mood {
            let entry = Entry(name: name, bodyText: body, mood: mood)
            saveToPersistentStore()
            put(entry: entry)
        } else {
            let entry = Entry(name: name, bodyText: body)
            saveToPersistentStore()
            put(entry: entry)
        }
    }
    
    func updateToCoreDate(name: String, body: String, mood: String, entry: Entry) {
        entry.name = name
        entry.bodyText = body
        entry.mood = mood
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.name = entryRepresentation.name
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        
        moc.performAndWait {
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("There was an error saving delete to persistent store: \(error)")
            }
        }
        
        deleteEntryFromServer(entry: entry)
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let id = entry.identifier ?? UUID().uuidString
        
        let jsonURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: jsonURL)
        request.httpMethod = "PUT"
    
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(entry)
        } catch {
            NSLog("Problem encoding data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        
        guard let id = entry.identifier else {
            NSLog("Entry missing identifier.")
            completion(nil)
            return
        }
        
        let jsonURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: jsonURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting data from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchSingleEntryFromPersistenceStore(entryID: String, context: NSManagedObjectContext) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", entryID)
        
        var entry: Entry?
        moc.performAndWait {
            do {
                entry = try moc.fetch(fetchRequest).first
            } catch {
                entry = nil
            }
        }
        return entry
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = {_ in }) {
        
        let jsonURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: jsonURL) { (data, _, error) in
            if let error = error {
                NSLog("There was an error fetching data from the server: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("There was an error unwrapping data from the server.")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode([String: EntryRepresentation].self, from: data)
                let entryReps = decodedData.map({ $0.value })
                
                let backgroundMOC = CoreDataStack.shared.container.newBackgroundContext()
                
                self.iterate(entryRepresentations: entryReps, context: backgroundMOC)
                completion(nil)
            } catch {
                NSLog("There was an issue decoding data from the server.")
                completion(NSError())
            }
        }.resume()
    }
    
    func iterate(entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext) {
        for rep in entryRepresentations {
            moc.performAndWait {
                let entry = self.fetchSingleEntryFromPersistenceStore(entryID: rep.identifier, context: context)
                
                if entry == nil {
                    Entry(entryRepresentation: rep)
                } else {
                    if rep == entry! {
                        return
                    } else {
                        self.update(entry: entry!, entryRepresentation: rep)
                    }
                }
                self.saveToPersistentStore()
            }
        }
    }
    
    func saveToPersistentStore() {
        moc.performAndWait {
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("There was an error saving to persistent store: \(error)")
            }
        }
    }
    
}
