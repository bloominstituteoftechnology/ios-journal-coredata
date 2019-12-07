//
//  EntryController.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData



class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    private func saveToPersistentStore() {
            let moc = CoreDataStack.shared.mainContext
            do {
                try moc.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
    }
    
    private func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
    
    func create(title: String, bodyText: String, mood: String, timeStamp: Date,  identifier: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        guard let entryIndex = entries.firstIndex(of: entry) else { return }
        
        entries[entryIndex].title = title
        entries[entryIndex].bodyText = bodyText
        entries[entryIndex].mood = mood
        entries[entryIndex].timeStamp = Date()
        saveToPersistentStore()
    }
    
    func delete(for entry: Entry) {
        guard let entryIndex = entries.firstIndex(of: entry) else { return }
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entries[entryIndex])
        saveToPersistentStore()
    }
    
    
}
