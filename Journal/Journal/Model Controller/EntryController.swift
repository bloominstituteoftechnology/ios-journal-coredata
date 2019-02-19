//
//  EntryController.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func create(name: String, body: String) {
        _ = Entry(name: name, bodyText: body)
        saveToPersistentStore()
    }
    
    func update(name: String, body: String, mood: String, entry: Entry) {
        entry.name = name
        entry.bodyText = body
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("There was an error saving delete to persistent store: \(error)")
        }
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("There was an error saving to persistent store: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("There was an error loading from persistent store: \(error)")
            return []
        }
    }
}
