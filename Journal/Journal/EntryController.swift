//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import CoreData
import Foundation

class EntryController {
    
    var entries: [Entry] {
       return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch let saveError {
            print("Error saving entries: \(saveError.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() ->[Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch let loadError {
            print("Error loading entries: \(loadError.localizedDescription)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String) {
        let _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodytext = bodyText
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch let deleteError {
            moc.reset()
            print("Error deleting entry \(deleteError.localizedDescription)")
        }
    }
}
