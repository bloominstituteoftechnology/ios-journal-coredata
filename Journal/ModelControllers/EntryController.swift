//
//  EntryController.swift
//  Journal
//
//  Created by macbook on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var coreDataStack: CoreDataStack?
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    //MARK: Save to Persistence
    // TODO: Check if you actually need this saveToPersisten function
    func saveToPersistentStore() {
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving \(error)")
        }
    }
    
//    //MARK: Load from Persistent
//    func loadFromPersistentStore() -> [Entry] {
//
//        //coreDataStack?.container
//
//        var entries: [Entry] {
//
//            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//            let moc = CoreDataStack.shared.mainContext
//            do {
//                let entries = try moc.fetch(fetchRequest)
//                return entries
//            } catch {
//                NSLog("Error fetching tasks: \(error)")
//                return []
//            }
//        }
//
//        return entries
//    }
    
    
    //MARK: CRUD
    
    // Create
    
    func createEntry(title: String, bodyText: String, mood: String) {
        _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    // Update
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood
        saveToPersistentStore()
    }
    
    // Delete
    
    //TODO: Delete from persitentStore
    func deleteEntry(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
}
