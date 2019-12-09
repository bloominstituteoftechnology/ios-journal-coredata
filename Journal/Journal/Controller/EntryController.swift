//
//  EntryController.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    // MARK: - Functions
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - CRUD Methods
    func create(mood: String, title: String, timestamp: Date, bodyText: String?, identifier: String?) {
        let _ = Entry(mood: mood, title: title, timestamp: timestamp, bodyText: bodyText, identifier: identifier)
        saveToPersistentStore()
    }
    
    func update(for entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(for entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}
