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
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Saving error: \(error)")
        }
        
    }
    func create(title: String, bodyText: String, mood: Mood) {
        _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
}
