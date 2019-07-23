//
//  EntryController.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //Properties
    var entries: [Entry] {
        
        return loadFromPersistentStore()
    }
    
    //Functions
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            
            try moc.save()
            
        } catch {
            
            NSLog("Error saving MOC: \(error)")
            moc.reset()
            
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching MOC: \(error)")
        }
        
        saveToPersistentStore()
        
        return []
    }
    
    func updateEntry(entry:Entry, title: String, bodyText: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        
        saveToPersistentStore()
        
    }
    
    func createEntry(title: String, bodyText: String? = nil) {
        
        _ = Entry(title: title, bodyText: bodyText)
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry)
        
        saveToPersistentStore()
    }
}
