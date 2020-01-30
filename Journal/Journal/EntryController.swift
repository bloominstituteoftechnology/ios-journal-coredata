//
//  EntryController.swift
//  Journal
//
//  Created by Ufuk Türközü on 27.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case put = "PUT"
}

class EntryController {
    
//    var entries: [Entry] {
//       loadFromPersistentStore()
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//            do {
//                return try context.fetch(fetchRequest)
//            } catch {
//                NSLog("Error fetching data: \(error)")
//                return []
//            }
//    }
    
let baseURL = URL(string: "https://journalfirebase-adb69.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else { return }
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion(nil)
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) {_, _, error in
            if let error = error {
                NSLog("Error putting task: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
        
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    @discardableResult func createEntry(with title: String, timestamp: Date, bodyText: String, identifier: String = UUID().uuidString, mood: String) -> Entry {
        
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, identifier: identifier, mood: mood, context: CoreDataStack.shared.mainContext)
        
        put(entry: entry)
        saveToPersistentStore()
        
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, timestamp: Date, bodyText: String, identifier: String = UUID().uuidString, mood: String) {
        
        entry.title = title
        entry.timestamp = Date()
        entry.bodyText = bodyText
        entry.identifier = identifier
        entry.mood = mood
        
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func deleteEntryFromServer(entry: Entry) {
        
    }
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
        deleteEntryFromServer(entry: entry)
    }
    
    
    
}
