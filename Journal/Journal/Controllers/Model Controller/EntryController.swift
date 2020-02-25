//
//  EntryController.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistenStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataTask.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataTask.shared.mainContext.reset()
        }
    }
    
    func loadFromPersistenStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataTask.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    @discardableResult func createEntry(called title: String, bodyText: String, timeStamp: Date, identifier: String, mood: String) -> Entry {
        let entry = Entry(title: title,
                          bodyText: bodyText,
                          timeStamp: timeStamp,
                          identifier: identifier,
                          mood: mood,
                          context: CoreDataTask.shared.mainContext)
        saveToPersistentStore()
        return entry
    }
    
    func update(entry: Entry, called title: String, bodyText: String, timeStamp: Date, identifier: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = timeStamp
        entry.identifier = identifier
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataTask.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
