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
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let baseURL = baseURL, let identifier = entry.identifier else { return }
        let uuid = UUID(uuidString: identifier) ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
//
//        let encoder = JSONEncoder()
//        do {
//            let data = try encoder.encode(entry.entryRepresentation)
//            request.httpBody = data
//        } catch {
//            print("Error encoding data: \(error)")
//            completion(error)
//            return
//        }
        
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
    private func saveToPersistentStore() {
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String?, timeStamp: Date, identifier: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
//        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(title: String, bodyText: String?, entry: Entry, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
//        saveToPersistentStore()
        guard let timeStamp = entry.timeStamp, let identifier = entry.identifier else { return }
        put(entry: Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood))
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
//        saveToPersistentStore()
//        deleteEntryFromServer(entry: entry, completion: nil)
        deleteEntryFromServer(entry: entry)
    }
    
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
        try CoreDataStack.shared.save(context: context)
    }
    
    func updateWith(_ entry: Entry, with representation: EntryRepresentation) {
        let mood = Mood(rawValue: representation.mood) ?? Mood.interesting
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = mood.rawValue
    }
}
