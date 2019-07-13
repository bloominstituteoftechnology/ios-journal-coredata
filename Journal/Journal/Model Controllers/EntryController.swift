//
//  EntryController.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    func createEntry(withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        self.saveToPersistentStore()
    }
    
    func updateEntry(withEntry entry: Entry, withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        self.saveToPersistentStore()
    }
    
    func deleteEntry(withEntry entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        self.saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
