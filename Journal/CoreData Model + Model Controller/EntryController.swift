//
//  EntryController.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // Create a new entry in the managed object context and save it to persistent store
    func createEntry(with title: String, bodyText: String?) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    // Update an existing entry in the managed object context, and save it to persistent store
    func update(entry: Entry, with title: String, bodyText: String?) {
        entry.title = title
        entry.bodyText = title
        entry.timestamp = Date()
        
        saveToPersistentStore()
    }
    
    // Delete an entry in the managed object context and save the new managed object content
    // to persistent store
    func delete(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
    
    // Save entries that are in the managed object context to persistent store
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // Load entries that are in the persistent store, into the managed object context
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
    
    // Entries computed property
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
}
