//
//  EntryController.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation

class EntryController {
    
    // MARK: - Properities
    private var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    // MARK: CRUD
    
    // Create
    private func create(identifier: String,
                        title: String,
                        bodyText: String? = nil,
                        timestamp: Date? = nil) {
        
        Entry(identifier: identifier,
              title: title,
              bodyText: bodyText,
              timestamp: timestamp,
              context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
    }

    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed error context: \(error)")
        }
    }

    // Read
    private func loadFromPersistentStore() -> [Entry] {
        return []
    }

    // Update
    // Delete
}
