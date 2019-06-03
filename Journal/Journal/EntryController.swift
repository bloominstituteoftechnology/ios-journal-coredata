//
//  EntryController.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //MARK: - Methods
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: String) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func updateEntry() {
        
    }
    
    func delteEntry() {
        
    }
    
    //MARK: - Properties
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
}
