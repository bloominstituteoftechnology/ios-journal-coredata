//
//  EntryController.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-fa29d.firebaseio.com/")!

class EntryController {
    
    var entries: [Entry] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
//    func saveToPersistentStore() {
//        do {
//            let moc = CoreDataStack.shared.mainContext
//            try moc.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
//    }
//
//    Inefficient way of loading, look at table view for better way (fetchedResultsController)
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Error fetching entries: \(error)")
//            return []
//        }
//    }
    
    func create(title: String, time: Date, description: String?, mood: String) {
        let entry = Entry(name: title, description: description, time: Date(), identification: UUID(), mood: Mood(rawValue: mood) ?? .normal)
        put(entry: entry)
        
    }
    
    func update(entry: Entry, newTitle: String, newDescription: String, newMood: String) {
        entry.title = newTitle
        entry.bodyText = newDescription
        entry.timestamp = Date()
        entry.mood = newMood
        put(entry: entry)
    }
    
    func delete(entry: Entry) {
        
        deleteEntryFromServer(entry) { error in
            if let error = error {
                print("Error deleting entry from server: \(error)")
                return
            }
            
            DispatchQueue.main.async {
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
    }
    
    // Firebase Stuff
    
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
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion()
            
            if let error = error {
                print("Error PUTing entry to server: \(error)")
            }
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (CompletionHandler) = { _ in }) {
         guard let uuid = entry.identifier else {
             completion(NSError())
             return
         }
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            context.delete(entry)
            try CoreDataStack.shared.save(context: context)
        } catch {
            context.reset()
            print("Error deleting object from managed object context: \(error)")
        }
         
         let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
         var request = URLRequest(url: requestURL)
         request.httpMethod = "DELETE"
         
         URLSession.shared.dataTask(with: request) { data, response, error in
             print(response!)
             completion(error)
         }.resume()
     }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier!) }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation)
            }
        } catch {
            print("Error fetching entries for UUIDs: \(error)")
        }
        
        try CoreDataStack.shared.save(context: context)
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data entry")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    init() {
        fetchEntriesFromServer()
    }
}


