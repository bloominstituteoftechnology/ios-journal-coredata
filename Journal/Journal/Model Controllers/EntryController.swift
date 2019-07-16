//
//  EntryController.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            let entry = try moc.fetch(fetchRequest)
            return entry
        } catch {
            NSLog("Error \(error)")
        }
        return[]
    }
    
    func createEntry(title: String, bodyText: String){
        let _ = Entry(title: title, bodyText: bodyText)
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
    }
    
    func delete(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
    }
}
