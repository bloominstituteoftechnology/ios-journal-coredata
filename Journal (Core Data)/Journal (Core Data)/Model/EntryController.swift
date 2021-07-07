//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties

    lazy private(set) var entries: [Entry] = {
        return loadFromPersistantStore()
    }()
    
    // MARK: - CRUD Methods

    // Create Entry
    func createEntry(withTitle title: String, bodyText: String) {
        entries.append(Entry(title: title, bodyText: bodyText))
        saveToPersistentStore()
    }
    
    // Update Entry
    func updateEntry(_ entry: Entry, updatedTitle: String, updatedBodyText: String) {
        let updatedTimestamp = Date()
        entry.title = updatedTitle
        entry.bodyText = updatedBodyText
        entry.timestamp = updatedTimestamp
        saveToPersistentStore()
        
        // Update Entry in entries array
        guard let index = entries.firstIndex(of: entry) else {
            print("WARNING: Could not update entry in EntryController.entries using updateEntry(:Entry, updatedTitle: \"\(updatedTitle)\", updatedBodyText: \"\(updatedBodyText)\"). No entry was found for identifier: \"\(entry.identifier ?? "nil")\".")
            return
        }
        
        entries[index].title = updatedTitle
        entries[index].bodyText = updatedBodyText
        entries[index].timestamp = updatedTimestamp
    }
    
    // Delete Entry
    func deleteEntry(_ entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
        
        // Delete Entry from entries array
        guard let index = entries.firstIndex(of: entry) else {
            print("WARNING: Could not delete entry from EntryController.entries using deleteEntry(:Entry). No entry was found for identifier: \"\(entry.identifier ?? "nil")\".")
            return
        }
        
        entries.remove(at: index)
    }
    
    // MARK: - Persistence

    private func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext // Managed Object Context
            try moc.save()
        } catch {
            print("Error saving to persistent store: \(error)")
        }
    }
    
    private func loadFromPersistantStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext // Managed Object Context
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
}
