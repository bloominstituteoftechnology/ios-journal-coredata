//
//  EntryController.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //MARK: - Properties
    
    lazy private (set) var entries: [Entry] = {
        loadFromPersistentStore()
    }()
    
    // MARK: - Persistence
    func saveToPersistentStore() {
        do {
            //managed object context
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving entry: \(error)")
        }
        
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
        
    }
    
    // MARK: - CRUD
    
    func createEntry(title: String, bodyText: String) {
        entries.append(Entry(title: title, bodyText: bodyText))
        
        saveToPersistentStore()
    }
    
    func updateEntry(_ entry: Entry, newTitle: String, newbodyText: String) {
        let updatedTimestamp = Date()
        entry.title = newTitle
        entry.bodyText = newbodyText
        entry.timestamp = updatedTimestamp
        saveToPersistentStore()
        
        guard let index = entries.firstIndex(of: entry) else { return }
        
        entries[index].title = newTitle
        entries[index].bodyText = newbodyText
        entries[index].timestamp = updatedTimestamp
    }
    
    func deleteEntry(_ entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
        guard let index = entries.firstIndex(of: entry) else { return }
        entries.remove(at: index)
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
        
    }
    
  
}
