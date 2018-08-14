//
//  EntryController.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func create(title: String, bodyText: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistenceStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        guard let index = entries.index(of: entry) else { return }
        let entry = entries[index]
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistenceStore()
    }
    
    func delete(entry: Entry) {
        guard let index = entries.index(of: entry) else { return }
        let entry = entries[index]
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            NSLog("Error deleting data from persistence store: \(error)")
        }
        
    }
    
    func saveToPersistenceStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving data from persistence store: \(error)")
        }
    }
    
    func loadFromPersistenceStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching data from persistence store: \(error)")
            return []
        }
    }
    
    var entries: [Entry] {
        return loadFromPersistenceStore()
    }
    
}
