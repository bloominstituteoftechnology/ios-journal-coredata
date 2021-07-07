//
//  EntryController.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore(){
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Unable to save.\n EntryController Line: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        do {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            fatalError("EntryController: Could not fetch entries. \n\(error)")
        }
    }
    
    var entries: [Entry] {
        // This will allow any changes to the persistent store become immediately
        // visible to the user when accessing this array
        let journalEntries = loadFromPersistentStore()
        return journalEntries
    }
    
    func create(title: String, bodyText: String) {
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        newEntry.title = title
        newEntry.bodyText = bodyText
        newEntry.timestamp = Date()
        newEntry.identifier = UUID().uuidString
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
