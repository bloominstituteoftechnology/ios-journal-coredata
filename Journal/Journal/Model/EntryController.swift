//
//  EntryController.swift
//  Journal
//
//  Created by Fabiola S on 10/2/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
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
            print("Error: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            print("Error \(error)")
            return []
        }
    }
    
    func addEntry(title: String, bodyText: String) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func editEntry(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) -> Bool {
        CoreDataStack.shared.mainContext.delete(entry)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            return true
        } catch {
            print("Error deleting: \(error)")
            return false
        }
    }
}
