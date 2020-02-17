//
//  EntryController.swift
//  Journal
//
//  Created by Eoin Lavery on 17/02/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

class EntryController {
    
    static var shared = EntryController()
    
    //MARK: - Properties
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    
    //MARK: - Public Functions
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            print("Error Saving To Persistent Store: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        }  catch {
           print("Error retrieving data from persistent store: \(error)")
            return []
        }
    }
    
    func createEntry(with name: String, notes: String?, date: Date = Date(), mood: String) {
        let _ = Entry(name: name, notes: notes, date: date, mood: mood)
        saveToPersistentStore()
    }
    
    func updateEntry(for updatedEntry: Entry, with name: String, notes: String?, date: Date = Date(), mood: String) {
        updatedEntry.name = name
        updatedEntry.notes = notes
        updatedEntry.mood = mood
        updatedEntry.date = date
        saveToPersistentStore()
    }
    
    func deleteEntry(for deletedEntry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(deletedEntry)
        
        do {
            try moc.save()
        } catch {
            print("Error deleting Entry from persistent store: \(error)")
        }
    }
    
}
