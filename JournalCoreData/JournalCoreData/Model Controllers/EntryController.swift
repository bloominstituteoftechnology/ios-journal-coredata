//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/14/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date? = Date(), identifier: String? = "", context: NSManagedObjectContext) {
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
//    func saveToPersistentStore(title: String, bodyText: String, timestamp: Date? = Date(), identifier: String? = "", context: NSManagedObjectContext) {
//        Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, context: context)
//        CoreDataStack.shared.saveToPersistentStore()
//    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
}
