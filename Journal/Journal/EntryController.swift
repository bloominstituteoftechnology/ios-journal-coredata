//
//  EntryController.swift
//  Journal
//
//  Created by Zack Larsen on 12/16/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entry: Entry?
    var entries: [Entry] = []
    
    func  saveToPersistentStore() {
        let moc = coreDataStack.shared.mainContext
        
        do {
            return try moc.save()
            
        } catch {
            print("Error saving entries: \(error.localizedDescription)")
            
        }
        
        
        
        func loadFromPersistentStore() -> [Entry] {
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            let moc = coreDataStack.shared.mainContext
            
            do {
                return try moc.fetch(fetchRequest)
            } catch {
                print("Error fetching tasks: \(error.localizedDescription)")
                return []
            }
        }
        
        func Create(title: String, bodyText: String, timestamp: Date = Date(), identifier: String) {
            
            let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
            
            do {
                let moc = coreDataStack.shared.mainContext
                try moc.save() /* every managed object, task or notes, are created in the moc*/
            } catch {
                print("Error saving managed object context: \(error.localizedDescription)")
            }
        }
        func Update(title: String, bodyText: String, timestamp: Date = Date()) {
            let entry = entryDetails.text
            let updateEntry = entry {
                //            Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
                entry.bodyText = bodyText
                entry.title = title
            } else {
                let _ = Entry(title: title, bodyText: bodyText, timestamp: timestamp)
            }
            do {
                let moc = coreDataStack.shared.mainContext
                try moc.save()
            } catch {
                print("Error updating entry: \(error.localizedDescription)")
            }
            
            
        }
        
        func Delete() {
            
        }
    }
}
