//
//  EntryController.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchedRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchedRequest)
        } catch {
            print("error fetching data: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        if let moodRaw = Mood(rawValue: mood) {
            let _ = Entry(title: title, bodyText: bodyText, mood: moodRaw)
            saveToPersistentStore()
        }
    }
    
    func updateEntry(title: String, bodyText: String, mood: String, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
}
