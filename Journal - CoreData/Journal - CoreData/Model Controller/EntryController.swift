//
//  EntryController.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import CoreData


class EntryController {
    
    var entry: Entry?
    
    func saveToPersistentStore() {
        guard entry != nil else { return }
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    var entries: [Entry] {
           loadFromPersistentStore()
          }
    
    func create(title: String, timestamp: Date, bodyText: String, mood: String) {
     
        let _ = Entry(title: title, timestamp: timestamp, mood: mood)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error creating new managed object context: \(error)")
        }
        
        saveToPersistentStore()
    }
    
    func update(entryUpdated: Entry, title: String, timestamp: Date, bodyText: String, mood: String) {
        
        
        
        
        saveToPersistentStore()
        
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        
    }
}
