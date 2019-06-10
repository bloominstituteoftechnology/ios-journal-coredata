//
//  EntryController.swift
//  Journal
//
//  Created by Thomas Cacciatore on 6/10/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // CRUD
    
    func createEntry(title: String, bodyText: String) {
        let _ = Entry(title: title, bodyText: bodyText)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        guard let index = entries.firstIndex(of: entry) else { return }
        entries[index].title = title
        entries[index].bodyText = bodyText
        entries[index].timeStamp = Date()
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        guard let index = entries.firstIndex(of: entry) else { return }
        let entry = entries[index]
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
    
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistenStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let entries = try moc.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching Entries: \(error)")
            return []
        }
    }
    
    
    
    var entries: [Entry] {
           return loadFromPersistenStore()
    }
}
