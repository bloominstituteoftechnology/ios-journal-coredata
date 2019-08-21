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
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
        
        let currentDateTime = Date()
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = currentDateTime
        entry.mood = mood.rawValue
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            deleteEntryFromServer(entry)
            saveToPersistentStore()
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
            
//            DispatchQueue.main.async {
                do {
                    let entryReps = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                    for entryRep in entryReps {
//                        let identifier = entryRep.identifier
//                        if let entry = self.fetchSingleEntryFromStore(UUID: identifier!) {
//
//                            self.update(entry: entry, with: entryRep)
                        
                        if let existingEntry = self.entry(for: UUID(uuidString: entryRep.identifier!)!)  {
                            // It's on the server so update it with what is on Firebase
                            existingEntry.title = entryRep.title
                            existingEntry.bodyText = entryRep.bodyText
                            existingEntry.timeStamp = entryRep.timeStamp
                            existingEntry.mood = entryRep.mood
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
//            }
            }.resume()
    }
    
//    private func updateEntries(with representations: [EntryRepresentation]) {
//
//        for representation in representations {
//            guard let identifier = representation.identifier,
//                let uuid = UUID(uuidString: identifier) else { return }
//
//            if let entry = entry(for: uuid) {
//
//                entry.title = representation.title
//                entry.bodyText = representation.bodyText
//                entry.identifier = representation.identifier
//                entry.mood = representation.mood
//
//            } else {
//
//                Entry(entryRepresentation: representation)
//
//            }
//        }
//
//    }
    
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
    
    
    private func entry(for uuid: UUID) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        fetchRequest.predicate = predicate
        
        do {
            let moc = CoreDataStack.shared.mainContext
            let task = try moc.fetch(fetchRequest).first
            
            return task
        } catch {
            NSLog("Error fetching task with UUID: \(uuid): \(error)")
            return nil
        }
        
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
    
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving MOC: \(error)")
            moc.reset()
        }
        
    }
    
    
    
}

