//
//  EntryController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - CRUD
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String?) {
        Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String?) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    private func loadFromPersistentStore() -> [Entry] {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(request)
            return entries
        } catch {
            NSLog("Error fetching Entry objects from main context: \(error)")
            return []
        }
    }
    
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving core data main context: \(error)")
        }
    }
}
