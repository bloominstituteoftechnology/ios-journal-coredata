//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Marc Jacques on 9/16/19.
//  Copyright © 2019 Marc Jacques. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    var entries: [Entry]
    
    func loadFromPersistentStoe() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func createAnEntry(with title: String, bodyText: String) -> Entry {
        
        let entry = Entry(title: title, bodyText: bodyText, context: CoreDataStack.shared.mainContext)
        entry.identifier = String(bodyText.prefix(25))
        entry.timeStamp = Date()
        
        saveToPersistentStore()
    }
    func updateEntry(entries: Entry, with title: String, bodyText: String?) {
        
        entries.bodyText = bodyText
        entries.title = title
        entries.timeStamp = Date()
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
