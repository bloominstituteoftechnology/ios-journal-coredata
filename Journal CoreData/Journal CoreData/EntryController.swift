//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Moin Uddin on 9/17/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    init() {
        fetchEntriesFromServer()
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.bodyText = entryRepresentation.bodyText
        entry.title = entryRepresentation.title
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        deleteFromServer(entry: entry)
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        }
        catch {
            NSLog("Error fetching: \(error)")
            return []
        }
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
           try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.predicate = predicate
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with UUID \(identifier): \(error)")
            return nil
        }
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = {_ in } ) {
        guard let identifier = entry.identifier else { return }
        var requestURL = baseUrl.appendingPathComponent(identifier)
        requestURL.appendPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                NSLog("There was an error with the PUT Request: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathExtension("json")
        //let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: requestURL) {data, _, error in
            if let error = error {
                NSLog("There was an error with the GET REQUEST: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("There was error unwrapping the data: \(error)")
                completion(error)
                return
            }
            
            var entryRepresentations: [EntryRepresentation] = []
            
            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                for entryRep in entryRepresentations {
                    if let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier) {
                        if entry != entryRep {
                            print("goes to update")
                           self.update(entry: entry, entryRepresentation: entryRep)
                        }
                    } else {
                        print("goes to create")
                        _ = Entry(entryRepresentation: entryRep)
                    }
                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                NSLog("There was an error decoding entries: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    
    func deleteFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else { return }
        var requestURL = baseUrl.appendingPathComponent(identifier)
        requestURL.appendPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                NSLog("There was an error with the DELETE Request: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    let baseUrl = URL(string: "https://moinjournal.firebaseio.com/")!

}
