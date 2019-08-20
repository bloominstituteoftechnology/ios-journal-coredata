//
//  EntryController.swift
//  Journal
//
//  Created by Bradley Yin on 8/19/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving to persistent:\(error)")
        }
    }

    func createEntry(with title: String, timeStamp: Date, bodyText: String, identifier: String, mood: Int64) {
        let _ = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, mood: Int64) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
