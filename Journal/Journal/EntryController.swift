//
//  EntryController.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properities
    // TODO: ? Why can't I use a private(set)
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    // MARK: CRUD
    
    // Create
    func create(identifier: String,
                title: String,
                bodyText: String? = nil,
                timestamp: Date? = nil) {
        
        var datetime = Date()
        if timestamp != nil {
            datetime = timestamp!
        }
        
        Entry(identifier: identifier,
              title: title,
              bodyText: bodyText,
              timestamp: datetime,
              context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
    }

    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed error context: \(error)")
        }
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
                bodyText: String? = nil) {

        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        
        Entry(identifier: entry.identifier ?? "",
              title: entry.title ?? "",
              bodyText: entry.bodyText,
              timestamp: entry.timestamp,
              context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
    }

    // Delete
    func delete(entry: Entry) {

        CoreDataStack.shared.mainContext.delete(entry)

        // TODO: ? Compare with this code
//        if let moc = person.managedObjectContext {
//            moc.delete(person)
//        }
        
        saveToPersistentStore()
    }
}
