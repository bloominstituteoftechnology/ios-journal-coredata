//
//  EntryController.swift
//  Journal
//
//  Created by John Kouris on 10/1/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            return entries
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
}
