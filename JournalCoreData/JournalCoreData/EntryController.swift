//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore(){
        
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
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
        
    }
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String){
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func updateEntry(title: String, bodyText: String, entry: Entry){
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
