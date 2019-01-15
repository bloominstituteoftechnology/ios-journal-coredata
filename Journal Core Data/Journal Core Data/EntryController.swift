//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    var entries: [Entry] {
        return loadFromPersistentStore()
    }

    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        var results = [Entry]()
        CoreDataStack.shared.mainContext.performAndWait {
            results = try! fetchRequest.execute()
        }
        return results
    }
    func createEntry(title: String, bodyText: String) {
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        newEntry.title = title
        newEntry.bodyText = bodyText
        saveToPersistentStore()
    }
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date.init()
        saveToPersistentStore()
    }
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
    }
}
