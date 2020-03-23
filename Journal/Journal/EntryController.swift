//
//  EntryController.swift
//  Journal
//
//  Created by Lydia Zhang on 3/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Saving error: \(error)")
        }
        
    }
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest :NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Loading error: \(error)")
            return []
        }
    }
    func create(title: String, bodyText: String) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    func update(entry: Entry, title: String, bodyText: String) {
        guard let index = entries.firstIndex(of: entry) else {return}
        entries[index].title = title
        entries[index].bodyText = bodyText
        saveToPersistentStore()
    }
    func delete(entry: Entry) {
        guard let index = entries.firstIndex(of: entry) else {return}
        let deleted = entries[index]
        moc.delete(deleted)
        saveToPersistentStore()
    }
}
