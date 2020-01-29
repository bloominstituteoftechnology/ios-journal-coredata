//
//  EntryController.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/27/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
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
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: String, mood: Mood) {
        // ?
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
        saveToPersistentStore()
    }
    
    func update(title: String, bodyText: String, mood: Mood, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        //print("UPDATED ENTRY: \(entry.title), \(entry.bodyText), \(entry.timestamp)")
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        print("DELETE")
        /*
        -Take an an Entry object to delete
        -Delete the Entry from the core data stack's mainContext
        -Save this deletion to the persistent store.
        */
    }
}
