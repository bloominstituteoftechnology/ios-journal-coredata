//
//  EntryController.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func createEntry(with title: String, bodyTitle: String, mood: Mood, context: NSManagedObjectContext) {
        
        Entry(title: title, bodyTitle: bodyTitle, mood: mood, context: context)
        CoreDataStack.shared.saveToPersistenceStore()
    }
    
    func updateEntry(entry: Entry, with title: String, bodyTitle: String, mood: Mood) {
        entry.title = title
        entry.bodyTitle = bodyTitle
        entry.mood = mood.rawValue
        CoreDataStack.shared.saveToPersistenceStore()
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistenceStore()
    }
}



