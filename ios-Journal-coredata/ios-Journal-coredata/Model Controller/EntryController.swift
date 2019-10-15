//
//  EntryController.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/15/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//    var entries: [Entry] {
//      loadFromPersistentStore()
//    }
    
   
    
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            let entries = try moc.fetch(fetchRequest)
//            return entries
//        } catch {
//            NSLog("Error fetching entries: \(error)")
//            return []
//        }
//    }

    
    func createEntry(with title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext) {
        
        Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}



