//
//  EntryController.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://journal-9006c.firebaseio.com/")!
    
    func createEntry(title: String, bodyText: String?, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        put(entry: entry)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        
        put(entry: entry)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping () -> Void = { }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response fetching entries, response code: \(response.statusCode)")
                completion()
                return
            }
            
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetching entries from server")
                completion()
                return
            }
            
            do {
                let decodedJSON = try JSONDecoder().decode([String : EntryRepresentation].self, from: data)
                let entryRepresentations = Array(decodedJSON.values)
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                self.updateEntries(with: entryRepresentations, context: backgroundContext)
                try CoreDataStack.shared.save(context: backgroundContext)
            } catch {
                NSLog("Error decoding entry representations \(error)")
                completion()
                return
            }
        }.resume()
    }
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(entry.entryRepresentation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    private func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        guard let uuid = UUID(uuidString: identifier) else { return nil }
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        var entry: Entry? = nil
        
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with uuid \(uuid): \(error)")
            }
        }
        
        return entry
    }
    
    private func update(entry: Entry, representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.identifier = UUID(uuidString: representation.identifier!)
    }
    
    private func updateEntries(with representations: [EntryRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for representation in representations {
                guard let identifier = representation.identifier else { return }
                let entry = fetchSingleEntryFromPersistentStore(identifier: identifier, context: context)
                
                if let entry = entry {
                    if entry != representation {
                        update(entry: entry, representation: representation)
                    }
                } else {
                    Entry(entryRepresentation: representation)
                }
            }
        }
    }
}
