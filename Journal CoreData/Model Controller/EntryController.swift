
//
//  EntryController.swift.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entry: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            // mainContext.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    @discardableResult func createEntry(with title: String, bodyText: String, identifier: String, timestamp: Date) -> Entry {
        
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
        
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, identifier: String, timestamp: Date) {
        
        entry.title = title
        entry.bodyText = bodyText
        // entry.identifier = identifier
        entry.timestamp = Date() // TODO: Not sure if correct format
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
        
    }
    
}
