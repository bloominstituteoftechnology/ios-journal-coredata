//
//  EntryController .swift
//  Journal
//
//  Created by brian vilchez on 9/16/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData
class EntryController {
    
    var entries: [Entry] {
    return loadFromPErsistence()
    }
    
    
    private func loadFromPErsistence() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            let tasks = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return tasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }

    }
    
    func createEntry(with title: String, bodytext: String, identifier:String, timeStamp: Date) -> Entry {
        let entry = Entry(title: title, bodyText: bodytext, identifier: identifier, timeStamp: timeStamp, context: CoreDataStack.shared.mainContext)
        return entry
    }
    
    func updateEntry(with entry: Entry, with title: String, bodytext: String, identifier:String, timeStamp: Date) {
        entry.bodyText = bodytext
        entry.identifier = identifier
        entry.timeStamp = timeStamp
        entry.title = title
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry(_ entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
