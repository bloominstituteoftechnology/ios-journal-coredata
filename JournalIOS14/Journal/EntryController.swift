//
//  EntryController.swift
//  Journal
//
//  Created by Ufuk Türközü on 24.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching data: \(error)")
//            return []
//        }
//    }
    
    let baseURL = URL(string: "https://journalfirebase-adb69.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = try JSONDecoder().decode([EntryRepresentation].self, from: data)
                self.updateServer(representations: entryRepresentations)
                completion()
            } catch {
                completion(error)
                return
            }
        }.resume()
    }
    
    // MARK: - CRUD
    
    @discardableResult func create(with title: String, timestamp: Date, bodyText: String, mood: EntryMood, id: String) -> Entry {
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, mood: mood, id: id, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.save()
        return entry
    }
    
    @discardableResult func update(entry: Entry, with title: String, timestamp: Date, bodyText: String, mood: EntryMood) -> Entry {
        entry.title = title
        entry.timestamp = Date()
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        //entry.identifier = identifier
        
        CoreDataStack.shared.save()
        return entry
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.save()
    }
    
    func updateServer(representation: [EntryRepresentation]) {
        
        let identifiersToFetch = representation.compactMap({ UUID(uuidString: $0.id)})
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representation))
        var entriesToCreate = representationByID
        
        do {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
            let existingEntries = CoreDataStack.shared.mainContext .fetch(fetchRequest)
        }
    }
}
