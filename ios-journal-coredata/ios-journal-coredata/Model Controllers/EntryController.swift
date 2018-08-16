//
//  EntryController.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

let baseURL: URL = URL(string: "https://stefanojournal.firebaseio.com/")!

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    enum HTTPMethods: String {
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    func create(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistenceStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistenceStore()
    }

    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            NSLog("Error deleting data from persistence store: \(error)")
        }

    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(error)
                return
            }
            
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values
                
                for entryRep in entryRepresentations {
                    if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: entryRep.identifier) {
                        if entry == entryRep {
                            self.update(entry: entry, entryRepresentation: entryRep)
                        }
                    } else {
                        let _ = Entry(entryRepresentation: entryRep)
                    }
                }
                
                self.saveToPersistenceStore()
                completion(nil)
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    // We provide the function with a default value of an empty closure
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("Could not get entry identifier for: \(entry)")
            completion(NSError())
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put.rawValue
        
        do {
            let jsonEntry = try JSONEncoder().encode(entry)
            request.httpBody = jsonEntry
        } catch {
            NSLog("Error encoding data: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("Could not get entry identifier for: \(entry)")
            completion(NSError())
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func saveToPersistenceStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving data from persistence store: \(error)")
        }
    }
    
    private func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
        entry.timestamp = entryRepresentation.timestamp
    }
    
    private func fetchSingleEntryFromPersistentStore(forUUID uuid: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error saving data from persistence store: \(error)")
            return nil
        }
    }
    
}
