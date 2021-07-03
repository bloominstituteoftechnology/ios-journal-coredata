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
    var entries: [Entry] {
        return loadFromPersistentStore()
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
    
    func createEntry(withTitle title: String, withBodyText bodyText: String?) {
        let _ = Entry(title: title, bodyText: bodyText)
        self.saveToPersistentStore()
    }
    
    func updateEntry(withEntry entry: Entry, withTitle title: String, withBodyText bodyText: String?) {
        guard let i = entries.firstIndex(of: entry) else { return }
        self.entries[i].title = title
        self.entries[i].bodyText = bodyText
        self.entries[i].timestamp = Date()
        self.saveToPersistentStore()
    }
    
    func deleteEntry(withEntry entry: Entry) {
        guard let i = entries.firstIndex(of: entry) else { return }
        let moc = CoreDataStack.shared.mainContext
        moc.delete(self.entries[i])
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
