//
//  EntryController.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - CRUD Methodfs
    
    func create(title: String, bodyText: String?) {
        Entry(title: title, bodyText: bodyText, context: CoreDataStack.shared.mainContext)
        saveToPersistentStore()
    }
    
    func update(for entry: Entry, title: String, bodyText: String?) {
        entry.title = title
        entry.bodyText = bodyText ?? ""
    }
    
    // MARK: - Peristence Methods
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() /*-> [Entry]*/ {
        
    }
}
