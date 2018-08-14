//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 14/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

class EntryController
{
    var entries: [Entry]
    {
        return loadFromPersistence()
    }
    
    func updateEntry(on entry: Entry, with title: String, note: String)
    {
        entry.title = title
        entry.note = note
        entry.timestamp = Date()
        
        saveToPersistence()
    }
    
    func saveToPersistence()
    {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error {
            NSLog("Failed to save to persistence: \(error)")
        }
    }
    
    func loadFromPersistence() -> [Entry]
    {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            print("Failed to fetch entries:", error)
            return []
        }
    }
    
    func deleteEntry(on entry: Entry)
    {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistence()
    }
    
}






