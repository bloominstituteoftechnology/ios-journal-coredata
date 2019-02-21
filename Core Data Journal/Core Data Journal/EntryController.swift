//
//  EntryController.swift
//  Core Data Journal
//
//  Created by Jaspal on 2/18/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    func updatePersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Could not update Persistent Store \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Could not load from Persistent Store: \(error)")
            return []
        }
        
    }
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    // Implement CRUD
    
    func create(title: String, bodyText: String) {
        // Initialize Entry object and save it to Persistent Store
        Entry(title: title, bodyText: bodyText)
        updatePersistentStore()
    }
    
    func update(title: String, bodyText: String, timestamp: Date = Date(), entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        updatePersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        updatePersistentStore()
    }
}
