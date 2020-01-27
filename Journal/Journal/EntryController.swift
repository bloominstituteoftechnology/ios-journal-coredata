//
//  EntryController.swift
//  Journal
//
//  Created by Ufuk Türközü on 27.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
       loadFromPersistentStore()
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
            do {
                return try context.fetch(fetchRequest)
            } catch {
                NSLog("Error fetching data: \(error)")
                return []
            }
    }
    
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    @discardableResult func createEntry(with title: String, timestamp: Date, bodyText: String, identifier: String) -> Entry {
        
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, identifier: identifier, context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
        
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, timestamp: Date, bodyText: String, identifier: String) {
        
        entry.title = title
        entry.timestamp = timestamp
        entry.bodyText = bodyText
        entry.identifier = identifier
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    
}
