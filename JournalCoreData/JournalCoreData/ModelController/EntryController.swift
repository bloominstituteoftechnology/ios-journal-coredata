//
//  EntryController.swift
//  JournalCoreData
//
//  Created by admin on 10/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    static let shared = CoreDataStack()
    
    // Set up a persistent container
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
         return container.viewContext
     }
    
    func loadFromPersistentStore() -> [Entry] {
        
        var tasks: [Entry]
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        do {
            let tasks = try moc.fetch(fetchRequest)
            return tasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
        
    }
    
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
    }
    
    func createEntry(with title: String, bodyText: String, timestamp: Date, identifier: String, context: NSManagedObjectContext) {
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, timestamp: Date, identifier: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.identifier = identifier
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry() {
        do {
            try mainContext.deleteEntry()
        } catch {
            NSLog("Error deleting entry: \(error)")
            mainContext.reset()
        }
    }
    
}
