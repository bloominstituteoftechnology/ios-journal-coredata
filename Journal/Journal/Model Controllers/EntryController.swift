//
//  EntryController.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func createEntry(with title: String, bodyText: String, timestamp: Date, identifier: String, context: NSManagedObjectContext) {
        
        Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, timestamp: Date, identifier: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.identifier = identifier
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {

        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
