//
//  EntryController.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://ios14-journal-entry-server.firebaseio.com/")!

class EntryController {
        
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    // MARK: - Server API Methods
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in  }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else {
                print("Error fetching entries from server: \(error!)")
                completion(error)
                return
            }
            guard let data = data else {
                print("No data returned by data task.")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let entryRepresentations = Array(try jsonDecoder.decode([String : EntryRepresentation].self, from: data).values)
                //                var entryRepresentations: [EntryRepresentation] = []
                //                let entryRepresentationsByID = try jsonDecoder.decode([String : EntryRepresentation].self, from: data)
                //                entryRepresentations = entryRepresentationsByID.map { $0.value }
                
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
            }
        }.resume()
    }
    
     func update(entry: Entry, entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        entry.title = entryRepresentation.title
//        entry.bodyText = entryRepresentation.bodyText
//        entry.timestamp = entryRepresentation.timestamp
//        entry.identifier = entryRepresentation.identifier
//        entry.mood = entryRepresentation.mood
         Entry(entryRepresentation: entryRepresentation, context: context)
    }
    
     func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier! }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    self.update(entry: entry, entryRepresentation: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching entries for UUIDs: \(error)")
            }
        }
    }
    
     func putEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuidString = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
        guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuidString
            entry.identifier = uuidString
            try CoreDataStack.shared.save()
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error PUTting entry to server: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
     func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuidString = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil else {
                print("Error deleting entry: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
//     MARK: - CRUD Methods
    // Create Entry
    func createEntry(withTitle title: String, bodyText: String, mood: String) {
        let entry = Entry(mood: MoodPriority(rawValue: mood)!, title: title, bodyText: bodyText)
        putEntryToServer(entry)
    }

    // Update Entry
    func updateEntry(_ entry: Entry, updatedTitle: String, updatedBodyText: String, updatedMood: String) {
        let updatedTimestamp = Date()
        entry.title = updatedTitle
        entry.bodyText = updatedBodyText
        entry.timestamp = updatedTimestamp
        entry.mood = updatedMood
        putEntryToServer(entry)
    }
//
//    // Delete Entry
//    func deleteEntry(_ entry: Entry) {
//        deleteEntryFromServer(entry) { (error) in
//            guard error == nil else {
//                print("Error deleting entry from server: \(error!)")
//                return
//            }
//
//            let moc = CoreDataStack.shared.mainContext
//            moc.delete(entry)
//        }
//        deleteEntryFromServer(entry)
//    }
//
//     MARK: - Persistence
//    private func saveToPersistentStore() {
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            try moc.save()
//        } catch {
//            moc.reset()
//            print("Error saving to persistent store: \(error)")
//        }
//    }
}
