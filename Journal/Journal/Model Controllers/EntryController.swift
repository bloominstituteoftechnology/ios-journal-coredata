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
            
            DispatchQueue.main.async {
                do {
                    let entryReps = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                    for entryRep in entryReps {
                        let identifier = entryRep.identifier
                        if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: identifier) {
                            self.update(entry: entry, with: entryRep)
                        } else {
                            let _ = Entry(entryRepresentation: entryRep)
                        }
                    }
                    
                    self.saveToPersistentStore()
                    completion(nil)
                } catch {
                    NSLog("Error decoding task representations: \(error)")
                    completion(error)
                    return
                }
            }
        }.resume()
    }
    
    func fetchSingleEntryFromPersistentStore(forUUID uuid: String) -> Entry? {
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
    
    func createEntry(withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        self.saveToPersistentStore()
        self.put(entry: entry)
    }
    
    func updateEntry(withEntry entry: Entry, withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        self.saveToPersistentStore()
        self.put(entry: entry)
    }
    
    // Update Entry with Entry Representation from Server
    private func update(entry: Entry, with representation: EntryRepresentation) {
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
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            self.saveToPersistentStore()
        }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else { completion(NSError()); return }
            
            representation.identifier = uuid
            entry.identifier = uuid
            self.saveToPersistentStore()
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
