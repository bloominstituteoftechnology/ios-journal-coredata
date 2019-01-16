//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    var baseURL = URL(string: "https://ios-journal.firebaseio.com/")
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: CoreData Methods
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        var results = [Entry]()
//        CoreDataStack.shared.mainContext.performAndWait {
//            results = try! fetchRequest.execute()
//        }
//        return results
//        
//    }
    func createEntry(title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString) {
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        newEntry.title = title
        newEntry.bodyText = bodyText
        newEntry.mood = mood
        newEntry.timestamp = Date()
        newEntry.identifier = identifier
        put(entry: newEntry) { (_) in}
        saveToPersistentStore()
    }
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date.init()
        entry.mood = mood
        entry.identifier = identifier
        put(entry: entry) { (_) in}
        saveToPersistentStore()
    }
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    //MARK: Networking Methods
    func put(entry: Entry, completionHandler: @ escaping CompletionHandler) {
        let requestURL = baseURL?.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "PUT"
        do {
        request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            print("error encoding 'Entry' object into JSON")
            completionHandler(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error initiaing dataTask")
                completionHandler(error)
            }
        }.resume()
    }
}
