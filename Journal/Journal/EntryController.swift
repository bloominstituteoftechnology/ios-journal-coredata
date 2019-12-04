//
//  EntryController.swift
//  Journal
//
//  Created by Craig Swanson on 12/4/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
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
    
    func createEntry(for entry: Entry) {
        guard let title = entry.title,
            let timestamp = entry.timestamp,
            let identifier = entry.identifier else { return }
        let bodyText = entry.bodyText ?? ""
        
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func updateEntry(for entry: Entry) {
        // TODO: write logic for updateEntry
    }
    
    func deleteEntry(for entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
        
        // TODO: make sure to call reloadData() in the table view when deleting and entry
    }
}
