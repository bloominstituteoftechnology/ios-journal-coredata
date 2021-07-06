//
//  EntryController.swift
//  Journal
//
//  Created by Kobe McKee on 6/3/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    
    func createEntry(title: String, bodyText: String) {
        let _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        
        saveToPersistentStore()
    }
    
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching Entries: \(error)")
            return []
        }
    }
    
    
}
