//
//  EntryController.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import CoreData
import Foundation

class EntryController {
    
    private func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch let saveError {
            print("Error saving entries: \(saveError.localizedDescription)")
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch let deleteError {
            moc.reset()
            print("Error deleting entries: \(deleteError.localizedDescription)")
        }
    }
}
