//
//  EntryController.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        }
        catch {
            NSLog("There was an error while trying to get your entry array.")
            return []
        }
    }
    
    // MARK: - CRUD methods
    
    func create(title: String, bodyText: String, mood: EntryMood) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood = .neutral) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
    
}
