//
//  EntryController.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//    var entries: [Entry] {
//       return loadFromPersistentStore()
//        
//    }
    
    
    
    let formatter = DateFormatter()
    
    func createEntry(title: String, bodyText: String? = nil, mood: Mood) {
        Entry(title: title, bodyText: bodyText, mood: mood)
        self.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
        
        let currentDateTime = Date()
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = currentDateTime
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving MOC: \(error)")
            moc.reset()
        }
        
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(fetchRequest)
//
//        } catch {
//            NSLog("Error fetching Entries: \(error)")
//            return []
//        }
//
//    }
    
    
    
    
}

