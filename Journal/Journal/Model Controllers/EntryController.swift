//
//  EntryController.swift
//  Journal
//
//  Created by Fabiola S on 10/2/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case put = "PUT"
    case delete = "DELETE"
    case get = "GET"
}

class EntryController {
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    let baseURL = URL(string: "https://journal-b558a.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping () -> Void = {}) {
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(entry.entryRepresentation)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
        
        
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        do {
//            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//            return entries
//        } catch {
//            print("Error \(error)")
//            return []
//        }
//    }
    
    
    
    func addEntry(mood: String ,title: String, bodyText: String) {
        let entry = Entry(mood: mood, title: title, bodyText: bodyText)
        saveToPersistentStore()
        put(entry: entry)
    }

    func editEntry(entry: Entry, mood: String, title: String, bodyText: String) {
        entry.mood = mood
        entry.title = title
        entry.bodyText = bodyText
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) -> Bool {
        CoreDataStack.shared.mainContext.delete(entry)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            return true
        } catch {
            print("Error deleting: \(error)")
            return false
        }
    }
    
   
}
