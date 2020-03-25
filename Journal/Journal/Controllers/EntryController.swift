//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    

    
    
    // MARK: - Persistent Store
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving managed object context (saving to persistent store): \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error loading journal entries from core Data: \(error)")
//            return []
//        }
//    }
    
    // MARK: - CRUD
    func createEntry(title: String,
                     bodyText: String,
                     timestamp: Date,
                     mood: String,
                     context: NSManagedObjectContext) {
        let newEntry = Entry(title: title,
                             bodyText: bodyText,
                             timestamp: timestamp,
                             mood: mood,
                             context: CoreDataStack.shared.mainContext)
        context.insert(newEntry)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        let context = CoreDataStack.shared.mainContext
        context.delete(entry)
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        context.insert(entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        context.delete(entry)
        saveToPersistentStore()
    }
}

