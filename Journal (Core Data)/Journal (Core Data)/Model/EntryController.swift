//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-693f9.firebaseio.com/")!

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
    
    // MARK: - Public CRUD Methods

    // Create Entry
    func createEntry(withTitle title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
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
    
    // Delete Entry
    func deleteEntry(_ entry: Entry) {
        deleteEntryFromServer(entry) { (error) in
            guard error == nil else {
                print("Error deleting entry from server: \(error!)")
                return
            }
            
            //let moc = CoreDataStack.shared.mainContext
            guard let moc = entry.managedObjectContext else { return }
            
            moc.perform {
                do {
                    moc.delete(entry)
                    try CoreDataStack.shared.save(context: moc)
                } catch {
                    moc.reset()
                    print("Error deleting entry from managed object context: \(error)")
                }
            }
        }
    }
    
    // MARK: - Public Server API Methods
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in  }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else {
                print("Error fetching entries from server: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task.")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let entryRepresentations = Array(try jsonDecoder.decode([String : EntryRepresentation].self, from: data).values)
                
                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding entry representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }
    
    // MARK: - Private Server API Methods
    
    private func putEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let moc = entry.managedObjectContext else { return }
        
        var uuidString = ""
        
        moc.perform {
            uuidString = entry.identifier ?? UUID().uuidString
        }
        
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        
        moc.perform {
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
    
    private func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let moc = entry.managedObjectContext else { return }
        
        moc.perform {
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
    }
        
    // MARK: - Private Methods

    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let representationsWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = representationsWithID.compactMap { $0.identifier! }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representationsWithID))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                // Delete existing entries not found in server database
                let allExistingEntries = try context.fetch(Entry.fetchRequest()) as? [Entry]
                let entriesToDelete = allExistingEntries!.filter { !identifiersToFetch.contains($0.identifier!) }
                
                for entry in entriesToDelete {
                    context.delete(entry)
                }
                
                // Update existing entries found in server database
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
                // Create new entries found in server database
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching entries for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
    }
    
    private func update(entry: Entry, with entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
}
