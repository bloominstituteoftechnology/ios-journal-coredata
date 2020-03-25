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

    private func update(entry: Entry, with representation: EntryRepresentation) {
        //entry.identifier = representation.identifier
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood = representation.mood
    }

    /// <#Description#>
    /// - Parameter representations: EntryRepresentation objects that are fetched from Firebase
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        
        /// Create a fetch request from Entry object.
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()

        /// Create a dictionary with the identifiers of the representations as the keys, and the values as the representations. To accomplish making this dictionary you will need to create a separate array of just the entry representations identifiers. You can use the zip method to combine two arrays of items together into a dictionary.
        let entriesByID = representations.filter { !$0.identifier.isEmpty }
        let identifiersToFetch = entriesByID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesByID))
        var entriesToCreate = representationsByID

        /// Give the fetch request an NSPredicate. This predicate should see if the identifier attribute in the Entry is in identifiers array that you made from the previous step. Refer to the hint below if you need help with the predicate.
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        /// Perform the fetch request on your core data stack's mainContext.
        let context = CoreDataStack.shared.mainContext
        
        do {
            /// This will return an array of Entry objects whose identifier was in the array you passed in to the predicate.
            let existingEntries = try context.fetch(fetchRequest)
            
            /// Loop through the fetched entries and call update. Then remove the entry from the dictionary. Afterwards we'll create entries from the remaining objects in the dictionary. The only ones that would remain after this loop are ones that didn't exist in Core Data already.
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            /// Create an entry for each of the values in entriesToCreate using the Entry initializer that takes in an EntryRepresentation and an NSManagedObjectContext
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            /// Make sure you handle a potential error from the fetch method on your managed object context, as it is a throwing method.
            NSLog("Error fetching tasks for UUIDs: \(error)")
        }
        
        // TODO: ? This isn't under both loops. Concerned about saving too much
        /// Under both loops, call saveToPersistentStore() to persist the changes and effectively synchronize the data in the device's persistent store with the data on the server. Since you are using an NSFetchedResultsController, as soon as you save the managed object context, the fetched results controller will observe those changes and automatically update the table view with the updated entries.
        try context.save() // Caller will handle
    }
    
    // Delete
    func delete(entry: Entry) {

        CoreDataStack.shared.mainContext.delete(entry)

        // TODO: ? Compare with this code
//        if let moc = person.managedObjectContext {
//            moc.delete(person)
//        }
        
        saveToPersistentStore()
        
        // FIXME: Firebase delete. EntryController Step 4 and 5.
    }
}
