//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData
class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
    
    do {
       try CoreDataStack.shared.mainContext.save() // has to see with books array.
        
    } catch {
       NSLog("error saving managed obejct context: \(error)")
    }
    }
    
    
    func loadFromPersistentStore() -> [Entry] {
           
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
           do {
               return try CoreDataStack.shared.mainContext.fetch(request)
           } catch{
               NSLog("Error in adding entry: \(error)")
           return []
           }
       }
    func createEntry(title: String, bodyText: String, timeStamp: Date, mood: String, identifier: String) -> Entry {
        
        let newEntry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood,  context: CoreDataStack.shared.mainContext)
        return newEntry
    }
    
    func updateEntry(entryTitle: String, bodyText: String, entry: Entry, mood: String) {
        entry.title = entryTitle
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    }
