//
//  EntryController.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] = []
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
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
    
    func create(title: String, time: Date, description: String?, mood: String, identifier: String) {
        let _ = Entry(name: title, description: description, time: Date(), identification: identifier, mood: Mood(rawValue: mood) ?? .normal)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newDescription: String, newMood: String) {
        entry.title = newTitle
        entry.bodyText = newDescription
        entry.timestamp = Date()
        entry.mood = newMood
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
}


