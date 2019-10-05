//
//  EntryController.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    
    var entries: [JournalEntry] {
        return self.loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [JournalEntry] {
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, body: String, mood: EntryMood) {
        let _ = JournalEntry(title: title, bodyText: body, mood: mood)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: JournalEntry, newTitle: String, newBody: String, newMood: EntryMood) {
        guard !newTitle.isEmpty else { return }
        entry.title = newTitle
        entry.bodyText = newBody
        entry.mood = newMood.stringValue
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: JournalEntry) {
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error deleting entry: \(error)")
        }
    }
}
