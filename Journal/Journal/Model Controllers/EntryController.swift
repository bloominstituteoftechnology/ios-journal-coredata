//
//  EntryController.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class EntryController {
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
//        
//    func loadFromPersistentStore() -> [Entry] {
//            
//            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//            
//            let moc = CoreDataStack.shared.mainContext
//            
//            do {
//                let entries = try moc.fetch(fetchRequest)
//                return entries
//            } catch {
//                NSLog("Error fetching tasks: \(error)")
//                return []
//            }
//    }
    
    func createEntry(with title: String, bodyText: String, mood: String, context: NSManagedObjectContext) {
        
        Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {

        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
