//
//  EntryController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save() // Save the task to the persistent store.
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
  /*  func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // We could say what kind of tasks we want fetched.
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
        
    }*/
   
  /*  var entries: [Entry] {
        return loadFromPersistentStore()
    }*/
    
    func create(withTitle title: String, andBody bodyText: String, andMood mood: String?){
        _ = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID().uuidString, mood: EntryMood(rawValue: mood ?? "neutral")!)
        saveToPersistentStore()
    }
    
   /* func update(withEntry entry: Entry, andTitle title: String, andBody bodyText: String, andMood mood: String) {
        guard let index = entries.index(of: entry) else { return }
        
        entries[index].title = title
        entries[index].bodyText = bodyText
        entries[index].mood = mood
        entries[index].timestamp = Date()
        
        saveToPersistentStore()
    }*/
    
    func delete(withEntry entry: Entry) {
      
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry) // Remove from the MOC, but not the persistent store
        
        do {
            try moc.save() // Carry the removal of the task, from the MOC, to the persistent store
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
