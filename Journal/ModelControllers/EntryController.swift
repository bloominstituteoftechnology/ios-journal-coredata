//
//  EntryController.swift
//  Journal
//
//  Created by macbook on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var coreDataStack: CoreDataStack?
    
    //MARK: Save to Persistence
    // TODO: Check if you actually need this saveToPersisten function
    func saveToPersistentStore() {
        coreDataStack?.saveToPersistentStore()
    }
    
    //MARK: Load from Persistent
    func loadFromPersistentStore() -> [Entry] {
        
        //coreDataStack?.container
        
        
        var entries: [Entry] {
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            
            let moc = CoreDataStack.shared.mainContext
            do {
                let entries = try moc.fetch(fetchRequest)
                return entries
            } catch {
                NSLog("Error fetching tasks: \(error)")
                return []
            }
        }
        return entries
    }
    
    //MARK: CRUD
    
    // Create
    
    func createEntry(title: String, bodyText: String, context: NSManagedObjectContext) {
        Entry(title: title, bodyText: bodyText, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Update
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Delete
    
    func deleteEntry(entry: Entry) {
        
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    
    
    
}
