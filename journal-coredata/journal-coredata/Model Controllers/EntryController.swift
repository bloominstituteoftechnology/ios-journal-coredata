//
//  EntryController.swift
//  journal-coredata
//
//  Created by Alex Shillingford on 8/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    //MARK: - Properties
    var entries: [Entry] {
        let entries = loadFromPersistentStore()
        return entries
    }
    
//    let df = DateFormatter()
    //MARK: - Persistence
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving moc: \(error)")
            moc.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error loading entries: \(error)")
            return []
        }
    }
    
    //MARK: - CRUD Methods
    func createEntry(title: String, bodyText: String) {
//        df.dateFormat = "MM-dd-yyyy HH:mm:ss"
        Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: Date) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
}
