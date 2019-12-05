//
//  EntryController.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    private let moc = CoreDataStack.shared.mainContext

    
    private var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String?, timeStamp: Date, identifier: String) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timeStamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func updateEntry(title: String, bodyText: String?, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    private func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
    
    private func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetchign tasks: \(error)")
            return []
        }
    }
}
