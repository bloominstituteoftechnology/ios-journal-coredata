//
//  EntryController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-6874f.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding/saving entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        print("IT IS FETCHING")
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
            } catch {
                NSLog("Error decoding or saving data from Firebase: \(error)")
                completion(error)
            }
        }.resume()
        
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
         let entriesByID = representations.filter { $0.identifier != nil}
        let identifiersToFetch = entriesByID.compactMap { $0.identifier }
         let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesByID))
         var entryToCreate = representationsByID
         
         let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
         
        let context = CoreDataStack.shared.container.newBackgroundContext()
         
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else {continue}
                    self.update(entry: entry, with: representation)
                    entryToCreate.removeValue(forKey: id)
                }
                
                for representation in entryToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                NSLog("Error fetching entries for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
     }
    
    // DOES NOT WORK YET
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        print("IT SHOULD BE DELETING")
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    /*
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
 */
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, mood: FaceValue) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: Date(), mood: mood, context: CoreDataStack.shared.mainContext)
        put(entry: entry)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func updater(entry: Entry, title: String, bodyText: String, mood: FaceValue) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood.rawValue
        put(entry: entry)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timeStamp = DateFormatter.shortFormatter.date(from: representation.timeStamp) ?? Date()
        entry.mood = representation.mood
    }
    
    
//    func loadFromPersistentStore() -> [Entry] {
//        var allEntries: [Entry] = []
//        let fetchRequest =
//          NSFetchRequest<NSManagedObject>(entityName: "Entry")
//
//        do {
//            allEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest) as! [Entry]
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        return allEntries
//    }
    
}
