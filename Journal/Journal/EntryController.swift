//
//  EntryController.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
    loadFromPersistentStore()
        
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    func createEntry(with title: String, bodyTitle: String, context: NSManagedObjectContext) {
        
        Entry(title: title, bodyTitle: bodyTitle, context: context)
        CoreDataStack.shared.saveToPersistenceStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyTitle: String) {
        
        entry.title = title
        entry.bodyTitle = bodyTitle
        CoreDataStack.shared.saveToPersistenceStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistenceStore()
    }
}




