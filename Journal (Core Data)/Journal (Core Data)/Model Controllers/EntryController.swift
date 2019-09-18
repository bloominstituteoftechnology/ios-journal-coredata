//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context on line \(#line) in file \(#file): \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String, timeStamp: Date, mood: Mood) {
        _ = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: "id", mood: mood, context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timeStamp: Date = Date(), mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = timeStamp
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
