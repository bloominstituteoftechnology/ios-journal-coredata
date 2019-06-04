//
//  EntryController.swift
//  Journal
//
//  Created by Jeremy Taylor on 6/3/19.
//  Copyright © 2019 Bytes Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
   
    func createEntry(title: String, bodyText: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: Mood(rawValue: mood)!)
       saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String, timestamp: Date = Date()) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = timestamp
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to core data: \(error)")
        }
    }
}
