//
//  EntryController.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    // save to PersistentStore

    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error Saving Task: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error Fetching Entries: \(error)")
            return []
        }
    }
    
    // create Entry
    
    func CreateEntry(title: String, bodytext: String, timestamp: Date, identifier: String) {
        let _ = Entry(title: title, bodytext: bodytext, timestamp: timestamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func Update(entry: Entry, newTitle: String, newBodyText: String) {
        let updatedTimeStamp = Date()
        entry.title = newTitle
        entry.bodytext = newBodyText
        entry.timestamp = updatedTimeStamp
        saveToPersistentStore()
        
    }
    
    //delete Entry
    
    func Delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving deleted entry: \(error)")
        }
    }

}
