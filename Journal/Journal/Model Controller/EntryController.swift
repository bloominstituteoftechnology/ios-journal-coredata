//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties

    
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

    // MARK: CRUD Methods
    
    func create(title: String, timestamp: Date, mood: String, bodyText: String?, identifier: String?) {
        let _ = Entry(title: title, timestamp: timestamp, mood: mood, bodyText: bodyText, identifier: identifier)
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
