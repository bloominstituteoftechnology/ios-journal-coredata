//
//  EntryController.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //MARK: Properties
    
    var entries: [Entry] {
        return self.loadFromPersistentStore()
    }
    let moc = CoreDataStack.shared.mainContext
    
    //MARK: Persistence
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            print("Error saving Data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching Data: \(error)")
            return []
        }
    }
    
    //MARK: CRUD
    
    func createEntry(mood: MoodPriority, title: String, body: String) {
        let _ = Entry(mood: mood, title: title, bodyText: body)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String, newMood: MoodPriority) {
        guard !newTitle.isEmpty else { return }
        entry.title = newTitle
        entry.bodyText = newBody
        entry.timestamp = Date()
        entry.mood = newMood.rawValue
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error deleting entry: \(error)")
        }
    }
    
}
