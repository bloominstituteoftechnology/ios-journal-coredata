//
//  EntriesController.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import Foundation
import CoreData

class EntriesController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving to persistent store: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching data from persistent store: \(error)")
            return []
        }
    }
    
    func createEntry(name: String, bodyText: String) {
        let _ = Entry(name: name, bodyText: bodyText)
        saveToPersistentStore()
    }

    func updateEntry(name: String, bodyText: String, entry: Entry) {
        entry.name = name
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
    }
    
}
