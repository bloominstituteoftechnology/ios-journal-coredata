//
//  EntryController.swift
//  Journal
//
//  Created by Brian Rouse on 5/18/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    // MARK: - iVars
    
    var entries: [Entry] {
        return loadFromPersistentStore()
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

    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext

        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }

    func create(title: String, bodyText: String) {
        Entry(identifier: "0", title: title, bodyText: bodyText, timestamp: Date())

        saveToPersistentStore()
    }

    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }

    func delete(entry: Entry) {

        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)

        saveToPersistentStore()
    }
}
