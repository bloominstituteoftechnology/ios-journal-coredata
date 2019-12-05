//
//  EntryController.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/2/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case host = "HOST"
    case delete = "DELETE"
}

class EntryController {
    
    let baseURL = URL(string: "https://lambdajournalforcoredata.firebaseio.com/")
    
    private let moc = CoreDataStack.shared.mainContext
    
    init() {
        fetchEntriesFromServer()
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let baseURL = baseURL, let identifier = entry.identifier else { return }
        let uuid = UUID(uuidString: identifier) ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(nil)
                return
            }
            representation.identifier = identifier
            entry.identifier = identifier
            
            try CoreDataStack.shared.mainContext.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task (or saving to persistent store): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier, let baseURL = baseURL else {
            completion(nil)
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            print("Deleted entry with idetifier: \(identifier)")
            completion(error)
        }.resume()
    }
    
    
    // MARK: METHODS FOR SAVING AND LOADING DATA
    
    func create(title: String, bodyText: String?, timeStamp: Date, identifier: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
        put(entry: entry)
    }
    
    func update(title: String, bodyText: String?, entry: Entry, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
        CoreDataStack.shared.save()
        guard let timeStamp = entry.timeStamp, let identifier = entry.identifier else { return }
        put(entry: Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood))
    }
    
//    func delete(entry: Entry) {
//        moc.delete(entry)
//        deleteEntryFromServer(entry: entry)
//        saveToPersistentStore()
//    }
    
    private func updateEntries(with representation: [EntryRepresentation]) throws {
        let entriesWithID = representation.filter({ $0.identifier != nil})
        let identifiersToFetch = entriesWithID.compactMap({ $0.identifier! })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                for entry in existingEntries {
                    guard let id  = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.updateWith(entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    let _ = Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching entries for UUIDS: \(error)")
            }
        }
        CoreDataStack.shared.save(context: context)
    }
    
    func updateWith(_ entry: Entry, with representation: EntryRepresentation) {
        let mood = Mood(rawValue: representation.mood) ?? Mood.interesting
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = mood.rawValue
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let baseURL = baseURL else { return }
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            var entries: [EntryRepresentation] = []
            do {
                let entryDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                for entry in entryDict.values {
                    entries.append(entry)
                }
                try self.updateEntries(with: entries)
            } catch {
                print("Error decoding array of entries: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
