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
    
    func createEntry(title: String, bodyText: String, mood: Moods) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Moods) {
        let modifiedEntry = entry
        modifiedEntry.title = title
        modifiedEntry.bodyText = bodyText
        modifiedEntry.timeStamp = Date()
        modifiedEntry.mood = mood.rawValue
        
        
        saveToPersistentStore()
        
    }
    
    func deleteEntry(entry: Entry) {
        let selectedEntry = entry
        let moc = CoreDataStack.shared.mainContext
        moc.delete(selectedEntry)
        
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

    
//    func loadFromPersistenStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            let entries = try moc.fetch(fetchRequest)
//            return entries
//        } catch {
//            NSLog("Error fetching Entries: \(error)")
//            return []
//        }
//    }
//
//
//
//    var entries: [Entry] {
//           return loadFromPersistenStore()
//    }
    
    
}
