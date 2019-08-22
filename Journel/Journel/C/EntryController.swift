//
//  EntryController.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //Properties
    var entries: [Entry] {
        // this adds the stored data to the "source of all truth"
        //remember computed properties need to RETURN a value. So this "return" returns the value that is retuned in the loadFromPersistentStore function
        return loadFromPersistentStore()
    }
}


//MOC functions
extension EntryController {

    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving MOC: \(error)")
            moc.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching MOC: \(error)")
        }
        saveToPersistentStore()
        return []
    }
}


//CRUD
extension EntryController {
    
    func create(title: String, bodyText: String? ) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String?, updatedTimeStamp: Date = Date()) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = updatedTimeStamp
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}


