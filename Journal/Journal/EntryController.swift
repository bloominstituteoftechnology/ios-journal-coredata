//
//  EntryController.swift
//  Journal
//
//  Created by Tobi Kuyoro on 24/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersitentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving to persistent store")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func loadFromPersitentStore() -> [Entry] {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try CoreDataStack.shared.mainContext.fetch(request)
        } catch {
            NSLog("Error loading entries: \(error)")
            return []
        }
    }
    
    @discardableResult
    func createEntry(called title: String, bodyText: String, timeStamp: Date, identifier: String) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier)
        saveToPersistentStore()
        return entry
    }
    
    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}

