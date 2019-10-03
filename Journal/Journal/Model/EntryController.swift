//
//  EntryController.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import CoreData
import Foundation

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    func savePersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Could not save entry \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Could not load entry \(error)")
            return []
        }
    }
    
    var entries: [Entry] {
        
        // load
        return loadFromPersistentStore()
    }
    
    // CRUD
    func create(title: String, bodyText: String) {
        // 
        _ = Entry(title: title, bodyText: bodyText)
        
        // save
        savePersistentStore()
    }
    
    func update(title: String,
                bodyText: String,
                timestamp: Date = Date(),
                entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
        // save
        savePersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        
        // save
        savePersistentStore()
    }
}
