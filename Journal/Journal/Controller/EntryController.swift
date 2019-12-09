//
//  EntryController.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    // MARK: - Functions
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching Entry: \(error)")
            return []
        }
    }
    
    // MARK: - CRUD Methods
    func create(mood: String, title: String, timestamp: Date, bodyText: String?, identifier: String?) {
        let _ = Entry(title: title, timestamp: timestamp, bodyText: bodyText, identifier: identifier)
        saveToPersistentStore()
    }
    
    func update(for entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(for entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}
