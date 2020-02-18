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
         let moc = CoreDataStack.shared.mainContext
        do {
            //managed object context
           
            try moc.save()
        } catch {
            moc.reset()
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
    
    func createEntry(title: String, bodyText: String, mood: String) {
        Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
    }
    
    func updateEntry(_ entry: Entry, newTitle: String, newbodyText: String, updatedMood: String) {
        let updatedTimestamp = Date()
        let updatedMood = updatedMood
        entry.mood = updatedMood
        entry.title = newTitle
        entry.bodyText = newbodyText
        entry.timestamp = updatedTimestamp
        saveToPersistentStore()
        
    
    }
    
    func deleteEntry(_ entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()

        
    }
    
  
}
