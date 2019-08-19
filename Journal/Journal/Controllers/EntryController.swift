//
//  EntryController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    // Create
    func createEntry(with title: String, bodyText: String, identifier: String, timeStamp: Date) {
        Entry(title: title, bodyText: bodyText, identifier: identifier, timeStamp: timeStamp)
        saveToPersistentStore()
    }
    
    // Update
    func updateEntry(entry: Entry, with title: String, bodyText: String, identifier: String, timeStamp: Date) {
        entry.title = title
        entry.bodyText = bodyText
        entry.identifier = identifier
        entry.timeStamp = timeStamp
        saveToPersistentStore()
    }
    
    // Delete
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    // Load
    func loadFromPersistentStore() -> [Entry] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching entries :\(error)")
            return []
        }
    }
    
    // Save
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving moc :\(error)")
            moc.reset()
        }
    }
}
