//
//  EntryController.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }

    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving to core data: \(error)")
        }
    }

//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            let allEntries = try moc.fetch(fetchRequest)
//            return allEntries
//        } catch {
//            print("Error fetching entries: \(error)")
//            return []
//        }
//    }
    
    func create(mood: EntryMood, title: String, bodyText: String?) {
    
        let _ = Entry(mood: mood, title: title, bodyText: bodyText)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func update(entry: Entry, mood: String, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.mood = mood
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }

}

