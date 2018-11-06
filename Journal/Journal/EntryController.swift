//
//  EntryController.swift
//  Journal
//
//  Created by Sean Hendrix on 11/5/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        var entries: [Entry] {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            let moc = CoreDataStack.shared.mainContext
            do {
                return try moc.fetch(fetchRequest)
            } catch {
                NSLog("Error fetching tasks: \(error)")
                return []
            }
        }
        return entries
    }
    
     
    func createEntry(title: String, bodyText: String) {
        let entry = Entry(title: title, bodyText: bodyText)
        
        saveToPersistentStore()
        
    }
    
    
    
    
}
