//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Seschwan on 7/10/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to core data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching the entries: \(error)")
        }
        return []
    }
    
    func createEntry(title: String, bodyText: String) {
        let _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.title     = title
        entry.bodyText  = bodyText
        entry.timestamp = timestamp
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}
