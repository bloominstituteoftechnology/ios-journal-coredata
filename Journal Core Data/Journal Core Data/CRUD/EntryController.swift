//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

// MARK: - New Model Controller using Database Sync Persistence (API Controller)

let baseURL = URL(string: "https://journal-iosw7.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
            URLSession.shared.dataTask(with: requestURL) { data, _, error in
                if let error = error {
                    print("Error fetching tasks: \(error)")
                    completion(error)
                    return
                }
                
                // must ensure data exists everywhere, so guard let is needed
                guard let data = data else {
                    print("No data returned by data task")
                    completion(NSError())
                    return
                }
                
                do {
                    let entryRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                    try self.updateEntries(with: entryRepresentation)
                } catch {
                    print("Error decoding task representations: \(error)")
                    completion(error)
                    return
                }
            }.resume()
        }

    
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion()
                return
            }
            
            representation.identifier = identifier
            let context = CoreDataStack.shared.mainContext
            try CoreDataStack.shared.save(context: context)
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error  in
            completion()
            
            if let error = error {
                print("Error PUTing task to server: \(error)")
            }
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { $0.identifier }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))

        var entriesToCreate = representationsByID
        
        let fetchReqeust: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchReqeust.predicate = NSPredicate(format: "identifier in %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()

        context.perform {
            do {
                let existingEntries = try context.fetch(fetchReqeust)
                
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
                print("Error fetching entries for identifiers: \(error)")
            }
        }
        try CoreDataStack.shared.save(context: context)
    }
    
    
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timeStamp = representation.timeStamp
        entry.identifier = representation.identifier
    }
    
    
    
    func deleteEntry(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            context.delete(entry)
            try CoreDataStack.shared.save(context: context)
        } catch {
            context.reset()
            print("Error deleting object from managed object context: \(error)")
        }
        
        let requestURL = baseURL.appendingPathExtension(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
        }.resume()
    }
    
    
    
    
    
    
//    func saveToPersistentStore() throws {
//        let moc = CoreDataStack.shared.mainContext
//        try moc.save()
//    }
    
}
    
    
// MARK: - Old Model Controller - Use this to refer back on how create, update, save, and delete entries were used before the fetchController
// old EntryController
//    var entries: [Entry] {
//        loadfromPersistentStore()
////        print("test")
//    }
//
//    func saveToPersistentStore() {
//        do {
//            let moc = CoreDataStack.shared.mainContext
//            try moc.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
//    }
//
////    // Day 1 Deletion
//    func loadfromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Fetch request of entry failed: \(error)")
//            return []
//        }
//    }
//
//    func create(title: String, bodyText: String, mood: Mood, identifier: String, timeStamp: Date) {
//        let _ = Entry(title: title, bodyText: bodyText, mood: mood, identifier: identifier, timeStamp: timeStamp)
//        saveToPersistentStore()
//    }
//
//    func update(_ entry: Entry, title: String, bodyText: String, mood: String, timeStamp: Date) {
//
//        guard let index = entries.firstIndex(of: entry) else { return }
//
//        entries[index].title = title
//        entries[index].bodyText = bodyText
//        entries[index].mood = mood
//        entries[index].timeStamp = Date()
//        saveToPersistentStore()
//    }
//
//    func delete(entry: Entry) {
//        guard let index = entries.firstIndex(of: entry) else { return }
//
//        let entry = entries[index]
//        let moc = CoreDataStack.shared.mainContext
//        moc.delete(entry)
//        do {
//            try moc.save()
//        } catch {
//            moc.reset()
//            print("Error saving managed object context (deletion): \(error)")
//        }
//        saveToPersistentStore()
//    }

