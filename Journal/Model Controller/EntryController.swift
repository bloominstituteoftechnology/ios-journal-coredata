//
//  EntryController.swift
//  Journal
//
//  Created by Andrew Ruiz on 10/14/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    // Create
    func createEntry(with title: String, bodyText: String, identifier: String, timestamp: Date, context: NSManagedObjectContext) {
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifer: identifier, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Update
    func updateEntry(entry: Entry, with title: String, bodyText: String, identifier: String, timestamp: Date) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        // Identifier will have default value?
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
}
