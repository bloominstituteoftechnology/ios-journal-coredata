//
//  EntryController.swift
//  Journal
//
//  Created by Sean Hendrix on 11/5/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-af2c7.firebaseio.com/")

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntrysFromServer()
    }
    
    func saveToPersistenceStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Could not save to disk: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    
//    func newEntry(title: String, bodyText: String, mood: String) {
//        _ = Entry(title: title, bodyText: bodyText, mood: mood)
//        saveToPersistenceStore()
//    }
    
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey: "bodyText")
        entry.setValue(Date(), forKey: "timestamp")
        entry.setValue(mood, forKey: "mood")
        
        saveToPersistenceStore()
    }
    
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistenceStore()
    }
    
    
    func fetchEntrysFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL!.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data returned from data entry.")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentationsDict = try JSONDecoder().decode([String : EntryRepresentation].self, from: data)
                let entryRepresentations = Array(entryRepresentationsDict.values)
                
                for entryRep in entryRepresentations {
                    
                    if let entry = self.entry(for: entryRep.identifier) {
                        guard let mood = Moods(rawValue: entryRep.mood) else { return }
                        self.update(entry: entry, with: entryRep.title, bodyText: entryRep.bodyText, mood: mood)
                    } else {
                        
                    }
                    
                }
                
                self.saveToPersistenceStore()
                completion(nil)
                
            } catch {
                NSLog("Error decoding Entry representations: \(error)")
                completion(error)
                return
            }
            
            }.resume()
    }
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        let identifer = entry.identifier ?? UUID()
        
        let requestURL = baseURL!.appendingPathComponent(identifer.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var entryRepresentation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            entryRepresentation.identifier = identifer.uuidString
            entry.identifier = identifer
            
            saveToPersistenceStore()
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
            
        } catch {
            NSLog("Error encoding Entry representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error PUTing Entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
            }.resume()
        
    }
    
    func delete(entry: Entry) {
        
        deleteEntryFromServer(entry: entry)
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try CoreDataStack.shared.save(context: moc)
        } catch {
            moc.reset()
            NSLog("Error saving moc after deleting task: \(error)")
        }
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("No identifier for Entry to delete")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL!.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
            }.resume()
    }
    
    func createEntry(with title: String, bodyText: String?, mood: Moods) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistenceStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, with title: String, bodyText: String?, mood: Moods) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        
        saveToPersistenceStore()
        put(entry: entry)
    }
    
    func entry(for identifier: String) -> Entry? {
        guard let identifier = UUID(uuidString: identifier) else { return nil }
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)
        fetchRequest.predicate = predicate
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with UUID: \(identifier): \(error)")
            return nil
        }
        
    }
    
    
//    private func update(entry: Entry, with representation: EntryRepresentation) {
//        task.name = representation.name
//        task.notes = representation.notes
//        task.priority = representation.priority.rawValue
//
//    }
//
//
//    private func entry(forUUID uuid: UUID) -> Entry? {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
//        let moc = CoreDataStack.shared.mainContext
//        return (try? moc.fetch(fetchRequest))?.first
//    }
    
}
