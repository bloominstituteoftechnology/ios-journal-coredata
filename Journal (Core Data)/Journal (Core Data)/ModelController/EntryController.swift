//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Michael on 1/27/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching tasks: \(error)")
//            return []
//        }
//    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: Mood(rawValue: mood) ?? .neutral)
        saveToPersistentStore()
    }
    
    func updateEntry(for entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func deleteEntry(for entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
