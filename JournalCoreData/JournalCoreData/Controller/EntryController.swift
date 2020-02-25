//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Enrique Gongora on 2/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //MARK: - Properties
    var entries: [Entry] {
       return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entry: \(error)")
            return []
        }
    }
    
    //MARK: - CRUD Methods
    
    // Create Method
    func createEntry(title: String, bodyText: String, mood: String) {
        _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    // Update Method
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        guard let index = entries.firstIndex(of: entry) else { return }
        entries[index].title = title
        entries[index].bodyText = bodyText
        entries[index].timestamp = Date()
        entries[index].mood = mood
        saveToPersistentStore()
    }
    
    // Delete Method
    func deleteEntry(for entry: Entry) {
        guard let index = entries.firstIndex(of: entry) else { return }
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entries[index])
        saveToPersistentStore()
    }
}
