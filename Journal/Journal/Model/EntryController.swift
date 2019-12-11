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
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    private func saveToPersistentStore() {
            let moc = CoreDataStack.shared.mainContext
            do {
                try moc.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
    }
    
//    private func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Error fetching entries: \(error)")
//            return []
//        }
//    }
    
    func create(title: String, bodyText: String, mood: String, timeStamp: Date) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        //guard let entryIndex = entries.firstIndex(of: entry) else { return }
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timeStamp = Date()
        saveToPersistentStore()
    }
    
    func delete(for entry: Entry) {
        //guard let entryIndex = entries.firstIndex(of: entry) else { return }
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    
}
