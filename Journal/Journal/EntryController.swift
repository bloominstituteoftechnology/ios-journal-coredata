//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
   
    
    // MARK: - Properties
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    let MC = CoreDataStack.shared.mainContext

    
    // MARK: - Methods
    
    func saveToPersistentStore() {
    do {
        try MC.save()
    } catch {
        NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetch: NSFetchRequest<Entry> = Entry.fetchRequest()
        do{
            return try MC.fetch(fetch)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
    
    // MARK: - CRUD
    
    // CREATE
    func create(title: String, timeStamp: Date, identifier: String, bodyText: String) {
        _ = Entry(title: title, timeStamp: timeStamp, identifier: identifier, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    // UPDATE
    func update(entry: Entry, title: String, bodyText: String) {
        
        guard let entryIndex = entries.firstIndex(of: entry) else { return }
        
        entries[entryIndex].title = title
        entries[entryIndex].bodyText = bodyText
        entries[entryIndex].timeStamp = Date()
    }
    
    // DELETE
    
    func delete(for entry: Entry) {
        guard let entryIndex = entries.firstIndex(of: entry) else { return }
        MC.delete(entries[entryIndex])
        saveToPersistentStore()
    }
}

