//
//  EntryController.swift
//  Journal.CoreData
//
//  Created by beth on 2/24/20.
//  Copyright © 2020 elizabeth wingate. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
         return loadFromPersistentStore()
     }
    
   static let shared = CoreDataStack()

    func saveToPersistentStore() {

        var container: NSPersistentContainer = {
             
        let container = NSPersistentContainer(name: "Tasks")
               container.loadPersistentStores { _, error in
        if let error = error {
        fatalError("Failed to load persistent stores:  \(error)")
    }
}
        return container
    }()
        var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
  }
    func loadFromPersistentStore() -> [Entry] {

    let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    let moc = CoreDataStack.shared.mainContext
        
    do {
            let entries = try moc.fetch(fetchRequest)
        return entries
    } catch {
        NSLog("Error fetching entries: \(error)")
        return []
    }
  }
    // MARK: - CRUD Methods
    
    // Create
   func create(title: String, timeStamp: Date, bodyText: String, identifier: String) {
    let _ = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier)
         saveToPersistentStore()
     }

    // Read
    // Update
     func update(entry: Entry, title: String, bodyText: String) {
           guard let entryIndex = entries.firstIndex(of: entry) else { return }

           entries[entryIndex].title = title
           entries[entryIndex].bodyText = bodyText
           entries[entryIndex].timeStamp = Date()
           saveToPersistentStore()
       }

    // Delete
    func delete(for entry: Entry) {
           guard let entryIndex = entries.firstIndex(of: entry) else { return }

           let moc = CoreDataStack.shared.mainContext
           moc.delete(entries[entryIndex])
           saveToPersistentStore()
  }
}
