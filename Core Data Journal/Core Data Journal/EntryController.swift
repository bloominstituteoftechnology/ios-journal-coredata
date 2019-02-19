//
//  EntryController.swift
//  Core Data Journal
//
//  Created by Jaspal on 2/18/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Could not save to Persistent Store \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Could not load from Persistent Store: \(error)")
            return []
        }
        
    }
    
}
