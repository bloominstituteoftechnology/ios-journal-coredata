//
//  EntryController.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    //MARK: Properties
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    let context = CoreDataStack.shared.mainContext
    
    //MARK: Create
    func createEntry(title: String, bodyText: String) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID())
        saveToPersistentStore()
    }
    
    //MARK: Read
    /**
     Loads all Journal Entries from Persistent Store
     */
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    //MARK: Update
    /**
     Saves whatever changes are in the mainContext
     */
    func saveToPersistentStore() {
           do {
               try CoreDataStack.shared.mainContext.save()
           } catch {
               NSLog("Saving Task failed with error: \(error)")
           }
    }
    
    func updateEntry(newTitle: String, newBodyText: String, entry: Entry) {
        entry.bodyText = newBodyText
        entry.title = newTitle
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    //MARK: Delete
    func deleteEntry(entry: Entry) {
        context.delete(entry)
        saveToPersistentStore()
    }
    
}
