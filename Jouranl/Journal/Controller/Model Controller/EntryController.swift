//
//  EntryController.swift
//  Journal
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import CoreData

class EntryController {

    var entries: [Entry] {
        loadFromPersistentStore()
    }

    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }

    func create(title: String, timestamp: Date, bodyText: String?, identifier: String) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifer: identifier)
        saveToPersistentStore()
    }

    func update(entry: Entry, newTitle: String, newDescription: String) {
        entry.title = newTitle
        entry.bodyText = newDescription
        entry.timestamp = Date()
        saveToPersistentStore()
    }

    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
}
