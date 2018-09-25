//
//  EntryController.swift
//  Journal
//
//  Created by Scott Bennett on 9/24/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] = [] {
        didSet {
            let _ = loadFromPersistentStore()
        }
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let entries = try moc.fetch(fetchRequest)
            print(entries)
            return entries
        } catch {
            NSLog("Error fetching entry: \(error)")
            return []
        }
    }
    
    func create(title: String, bodyText: String) {
       let _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String) {
        
        entry.title =  title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        
    }
    
}
