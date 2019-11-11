//
//  EntryController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    // MARK: - CRUD
    
    func create(title: String, body: String, timestamp: Date, id: String) {
        let _ = Entry(title: title, bodyText: body, timestamp: timestamp, identifier: id)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, toNewTitle title: String, body: String) {
        entry.title = title
        entry.bodyText = body
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    // MARK: - Save/Load
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest = CoreDataStack.shared.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching journal entries: \(error)")
            return []
        }
    }
}
