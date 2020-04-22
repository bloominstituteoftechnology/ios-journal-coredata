//
//  EntryController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}


class EntryController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://coredata-journal.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error sending task to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    
//    var entry: Entry?
//
//    func saveToPersistentStore() {
//        guard entry != nil else { return }
//
//        do {
//            try CoreDataStack.shared.mainContext.save()
//        } catch {
//            NSLog("Error saving managed object context: \(error)")
//            return
//        }
//
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching entries: \(error)")
//            return []
//        }
//    }
//
//    var entries: [Entry] {
//           loadFromPersistentStore()
//          }
//
//    func create(title: String, timestamp: Date, bodyText: String, mood: String) {
//
//        let _ = Entry(title: title, timestamp: timestamp, mood: mood)
//
//        do {
//            try CoreDataStack.shared.mainContext.save()
//        } catch {
//            NSLog("Error creating new managed object context: \(error)")
//        }
//
//        saveToPersistentStore()
//    }
//
//    func update(title: String, timestamp: Date, bodyText: String, mood: String) {
//
//        entry?.title = title
//        entry?.bodyText = bodyText
//        let date = Date()
//        entry?.timestamp = date
//        entry?.mood = mood
//
//        saveToPersistentStore()
//
//    }
//
//    func delete(entry: Entry) {
//
//        CoreDataStack.shared.mainContext.delete(entry)
//
//        do {
//            try CoreDataStack.shared.mainContext.save()
//        } catch {
//            NSLog("Error deleting the entry: \(error)")
//            return
//        }
//    }
}
