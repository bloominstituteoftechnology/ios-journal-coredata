//
//  EntryController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // Create
    func createEntry(with title: String, bodyText: String, identifier: String, timeStamp: Date, mood: Mood) {
        Entry(title: title, bodyText: bodyText, identifier: identifier, timeStamp: timeStamp, mood: mood)
        saveToPersistentStore()
    }
    
    // Update
    func updateEntry(entry: Entry, with title: String, bodyText: String, identifier: String?, timeStamp: Date, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.identifier = identifier
        entry.timeStamp = timeStamp
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    
    // Delete
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    // Save
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving moc :\(error)")
            moc.reset()
        }
    }
}
