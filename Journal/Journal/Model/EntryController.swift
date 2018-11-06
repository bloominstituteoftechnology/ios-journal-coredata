//
//  EntryController.swift
//  Journal
//
//  Created by Sean Hendrix on 11/5/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistenceStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Could not save to disk: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        // Same way of doing it I think
        // let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    
    func newEntry(title: String, bodyText: String) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistenceStore()
    }
    
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey: "bodyText")
        entry.setValue(Date(), forKey: "timestamp")
        
        saveToPersistenceStore()
    }
    
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistenceStore()
    }
    
    
}
