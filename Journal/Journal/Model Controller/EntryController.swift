//
//  EntryController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    
    lazy var entries: [Entry] = {
        loadFromPersistentStore()
    }()
    
    // MARK: - Persistence
    func saveToPersistentStore() {
        do {
            //managed object context
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving entry: \(error)")
        }
        
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
        
    }
    
    // MARK: - CRUD
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: String) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newbodyText: String) {
        entry.title = newTitle
        entry.bodyText = newbodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
