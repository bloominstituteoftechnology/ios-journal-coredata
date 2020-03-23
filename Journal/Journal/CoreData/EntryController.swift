//
//  EntryController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - CRUD
    
    
    
    // MARK: - Persistence
    
    func loadFromPersistentStore() -> [Entry] {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(request)
            return entries
        } catch {
            NSLog("Error fetching Entry objects from main context: \(error)")
            return []
        }
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving core data main context: \(error)")
        }
    }
    
    
    
    
}
