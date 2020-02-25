//
//  EntryController.swift
//  Journal
//
//  Created by Ufuk Türközü on 24.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching data: \(error)")
            return []
        }
    }
    
    // MARK: - CRUD
    
    @discardableResult func create(with title: String, timestamp: Date, bodyText: String, mood: EntryMood, id: String) -> Entry {
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, mood: mood, id: id, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.save()
        return entry
    }
    
    @discardableResult func update(entry: Entry, with title: String, timestamp: Date, bodyText: String, mood: EntryMood) -> Entry {
        entry.title = title
        entry.timestamp = Date()
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        //entry.identifier = identifier
        
        CoreDataStack.shared.save()
        return entry
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.save()
    }
}
