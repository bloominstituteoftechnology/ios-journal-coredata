//
//  EntryController.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error save managed ibject context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Entries: \(error)")
            return []
        }
        
    }
    
    func createEntry(title: String, body: String) {
        let _ = Entry(title: title, bodyText: body, timestamp: Date(), identifier: String(entries.count + 1))
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, body: String) {
        if let id = entry.identifier {
           let _ = Entry(title: title, bodyText: body, timestamp: Date(), identifier: id)
            saveToPersistentStore()
        }
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
}
