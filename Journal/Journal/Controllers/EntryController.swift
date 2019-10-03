//
//  EntryController.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/2/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    private let moc = CoreDataStack.shared.mainContext
    
    // MARK: METHODS FOR SAVING AND LOADING DATA
    private func saveToPersistentStore() {
        
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
    
    func create(title: String, bodyText: String?, timeStamp: Date, identifier: String) {
        let _ = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier)
        saveToPersistentStore()
    }
    
    func update(title: String, bodyText: String?, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
}
