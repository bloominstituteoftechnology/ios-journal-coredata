//
//  EntryController.swift
//  Journal
//
//  Created by Samantha Gatt on 8/13/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    
    // MARK: - CRUD
    
    func create(title: String, body: String?, mood: EntryMood) {
        let _ = Entry(title: title, body: body, mood: mood)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, body: String?, mood: EntryMood, timestamp: Date = Date()) {
        entry.title = title
        entry.body = body
        entry.mood = mood.rawValue
        entry.timestamp = timestamp
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving entry: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
}
