//
//  EntryController.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func createEntry(title: String, identifier: String, timestamp: Date = Date(), bodyText: String) {
        let _ = Entry(title: title, identifier: identifier, timestamp: timestamp, bodyText: bodyText)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataManager.shared.mainContext
        
        do {
            let entries = try moc.fetch(fetchRequest)
            if let entryIndex = entries.index(of: entry) {
                moc.delete(entries[entryIndex])
                try moc.save()
            }
        } catch {
            NSLog("Error with deleting entry")
        }
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataManager.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataManager.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
}
