//
//  EntryController.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData


class EntryController {
    
    // MARK: - Properties
    
    var entries: [Entry] = []
    
    // MARK: - Methods
    
    private func createEntry(title: String, bodyText: String) {
        
        let newEntry = Entry(title: title,
                             bodyText: bodyText,
                             timestamp: Date(),
                             identifier: String((entries.count + 1)))
        entries.append(newEntry)
        saveToPersistence()
        
    }
    
    private func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistence()
    }
    
    private func deleteEntry(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistence()
    }
    
    // MARK: - Persistence
    
    private func saveToPersistence() {
        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    private func loadFromPersistence() {
        
        var entries: [Entry]{
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            do {
                return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            } catch {
                NSLog("Error fetching entries: \(error)")
                return []
            }
            
        }
    }
    
}
