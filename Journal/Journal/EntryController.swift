//
//  EntryController.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

class EntryController {
    
    // MARK: - Properities
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://journal-lambda-gerrior.firebaseio.com/")!

    // TODO: ? Why can't I use a private(set).
    //    var entries: [Entry] {
    //        // Gets loaded each time. This is a get.
    //        // TODO: ? Is this a performance issue.
    //        loadFromPersistentStore()
    //    }
    
    // MARK: CRUD
    
    // Create
    func create(identifier: String,
                title: String,
                bodyText: String? = nil,
                timestamp: Date? = nil,
                mood: Mood = .neutral) {
        
        var datetime = Date()
        if timestamp != nil {
            datetime = timestamp!
        }
        
        let entry = Entry(identifier: identifier,
                          title: title,
                          bodyText: bodyText,
                          timestamp: datetime,
                          mood: mood,
                          context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()

        put(entry: entry)
    }

    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed error context: \(error)")
        }
    }

    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid // TODO: ? What if it didn't change?
            try CoreDataStack.shared.mainContext.save()
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding/saving task: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTing task to server \(error)")
                completion(error)
                return
            }

            completion(nil)
        }.resume()
    }

    // Read
    private func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
        }
        return []
    }

    // Update
    func update(entry: Entry,
                title: String,
                bodyText: String? = nil,
                mood: Mood = .neutral) {

        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        saveToPersistentStore()

        put(entry: entry)
    }

    // Delete
    func delete(entry: Entry) {

        CoreDataStack.shared.mainContext.delete(entry)

        // TODO: ? Compare with this code
//        if let moc = person.managedObjectContext {
//            moc.delete(person)
//        }
        
        saveToPersistentStore()
        
        // FIXME: Firebase delete
    }
}
