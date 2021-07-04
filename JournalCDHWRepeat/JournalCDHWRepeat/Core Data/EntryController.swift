//
//  EntryController.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/4/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func createEntry(title: String, bodyText: String){
        let _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newBody: String, newTimestamp: Date = Date()){
        entry.title = newTitle
        entry.bodyText = newBody
        entry.timestamp = newTimestamp
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch  {
            print("Error saving to persistent stores:\(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        var results: [Entry]
        do {
            results = try moc.fetch(fetchRequest)
            return results
        } catch  {
            print("Error loading from persistent store: \(error.localizedDescription)")
            return []
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
