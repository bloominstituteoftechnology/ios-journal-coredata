//
//  EntryController.swift
//  JournalCoreData
//
//  Created by John Holowesko on 2/14/20.
//  Copyright © 2020 John Holowesko. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    
    // MARK: - Properties
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    // MARK: - Functions
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func create(title: String, bodyText: String?) {
        let moc = CoreDataStack.shared.mainContext
        
        let _ = Entry(title: title, bodyText: bodyText)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print(error)
        }
    }
    
    func update(title: String, bodyText: String?, entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        let timestamp = Date()
        
        entry.bodyText = bodyText
        entry.title = title
        entry.timestamp = timestamp
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print(error)
        }
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print(error)
        }
    }
}
