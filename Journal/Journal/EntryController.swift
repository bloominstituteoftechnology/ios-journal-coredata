//
//  EntryController.swift
//  Journal
//
//  Created by Craig Swanson on 12/4/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // create the array of saved entries by calling the loadFromPersistentStore
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Error fetching entries: \(error)")
//            return []
//        }
//    }
    
    // create and update are passed an "Entry" object, so all I need to do here is save.  I wasn't sure what a better way might be while still having the createEntry and updateEntry methods here, as we were instructed to do.
    func createEntry(for entry: Entry) {
        saveToPersistentStore()
    }
    func updateEntry(for entry: Entry) {
        saveToPersistentStore()
    }
    
    // deleteEntry is passed an entry object, deletes it from the array and saves the results.
    func deleteEntry(for entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}
