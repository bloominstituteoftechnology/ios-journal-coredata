//
//  EntryController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let allEntries = try moc.fetch(fetchRequest)
            return allEntries
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
        
    }
    
    func Create(title: String, bodyText: String) {
        
        let _ = Entry(title: title, timestamp: Date(), bodyText: bodyText)
    
        saveToPersistentStore()
    }
    
    func Update(title: String, bodyText: String, entry: Entry) {
        
        entry.title = title
        entry.bodyText = bodyText
        
        saveToPersistentStore()
    }
    
    func Delete(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
    
    
    
}
