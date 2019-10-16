//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/14/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case representationNil
    case encodingError
    case putError
    case deleteError
}

class EntryController {
    
    let baseURL: URL = URL(string: "https://ios-journal-coredata.firebaseio.com/")!
    
    func createEntry(title: String, mood: JournalMood, bodyText: String, context: NSManagedObjectContext) {
        let entry = Entry(title: title, mood: mood, bodyText: bodyText, context: context)
        put(entry: entry) { (error) in
            if error == nil {
                CoreDataStack.shared.saveToPersistentStore()
            }
        }
    }
    
    func updateEntry(entry: Entry, title: String, mood: JournalMood, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        put(entry: entry) { (error) in
            if error == nil {
                CoreDataStack.shared.saveToPersistentStore()
            }
        }
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        deleteFromServer(entry: entry) { (error) in
            if error == nil {
                CoreDataStack.shared.saveToPersistentStore()
            }
        }
    }
    
//    func update(entry: Entry, representation: EntryRepresentation) {
//        entry.title = representation.title
//        entry.bodyText = representation.bodyText
//        entry.mood = representation.mood
//        entry.timestamp = representation.timestamp
//        entry.identifier = representation.identifier
//    }
//
//    func updateEntries(with representations: [EntryRepresentation]) {
//        let identifiersToFetch = representations.map({ $0.identifier })
//    }
    
    
    func put(entry: Entry, completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion(.representationNil)
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding Entry Representation: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting entry: \(error)")
                completion(.putError)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETING entry \(error)")
                completion(.deleteError)
            }
            completion(nil)
        }.resume()
        
    }
}
