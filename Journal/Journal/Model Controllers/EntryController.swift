//
//  EntryController.swift
//  Journal
//
//  Created by John Kouris on 10/1/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    @discardableResult func createEntry(with title: String, bodyText: String?) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, context: CoreDataStack.shared.mainContext)
        saveToPersistentStore()
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String?) {
        entry.title = title
        entry.bodyText = bodyText
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
}
