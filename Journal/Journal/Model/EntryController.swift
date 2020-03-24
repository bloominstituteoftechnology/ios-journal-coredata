//
//  EntryController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - CRUD
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String?, mood: Mood) {
        Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func update(_ entry: Entry, title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(_ entry: Entry) -> Error? {
        CoreDataStack.shared.mainContext.delete(entry)
        return saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    private func loadFromPersistentStore() -> [Entry] {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(request)
            return entries
        } catch {
            NSLog("Error fetching Entry objects from main context: \(error)")
            return []
        }
    }
    
    @discardableResult
    private func saveToPersistentStore() -> Error? {
        do {
            try CoreDataStack.shared.mainContext.save()
            return nil
        } catch {
            NSLog("Error saving core data main context: \(error)")
            return error
        }
    }
}
