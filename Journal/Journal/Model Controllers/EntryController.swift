//
//  EntryController.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let baseURL = URL(string: "https://journal-7b7fa.firebaseio.com/")!
    
    init() {
        self.fetchEntriesFromServer()
    }
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        let uuid = entry.identifier ?? UUID()
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion()
                return
            }
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error PUTting entry to server: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let uuid = entry.identifier!.uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error DELETEing entry to server: \(error)")
                completion(error)
                return
            }
            completion(error)
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter({ $0.identifier != nil })
        let identifiersToFetch = entriesWithID.compactMap({ UUID(uuidString: $0.identifier!) })
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        // this is bg context so it's fine without waiting
        context.perform {

            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationByID[id] else {
                            continue
                    }
                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    let _ = Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching entries for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data entry")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dictionaryOfEntries = try decoder.decode([String: EntryRepresentation].self, from: data)
                let entryRepresentations = Array(dictionaryOfEntries.values)
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

//    func saveToPersistentStore() {
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            try moc.save()
//        } catch {
//            print("Error saving to core data: \(error)")
//        }
//    }
    
    func create(mood: EntryMood, title: String, bodyText: String?) {
    
        let entry = Entry(mood: mood, title: title, bodyText: bodyText)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            self.put(entry: entry)
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func update(entry: Entry, mood: String, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.mood = mood
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            self.put(entry: entry)
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.mood = representation.mood
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
    }
    
    func delete(entry: Entry) {
        // delete from server
        self.deleteEntryFromServer(entry: entry)
        
        // delete from local
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }

}

