//
//  EntryController.swift
//  Journal - Day 2
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Create local dataset
//    var entries: [Entry]  {
//        return loadFromPersistentStore()
//    }
    
    // MARK: - Persistent save
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Unable to save to Persistent data file \(error)")
        }
    }
    
    // MARK: - CRUD functions
    
    // Crud
    func createEntry(title: String, bodyText: String) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    // cRud
//    func loadFromPersistentStore() -> [Entry] {
//        let moc = CoreDataStack.shared.mainContext
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Error fetching entries from persistent shares: \(error)")
//            return[]
//        }
//    }
    
    // crUd
    func update(entry: Entry, title: String, bodyText: String) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey: "bodyText")
        entry.setValue(Date(), forKey: "timestamp")
        saveToPersistentStore()
    }
    
    //cruD
    func delete(delete: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(delete)
        saveToPersistentStore()
    }
    
}  // Class
