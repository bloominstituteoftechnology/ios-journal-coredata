//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 14/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

class EntryController
{
    func updateEntry(on entry: Entry, with title: String, note: String, mood: String)
    {
        entry.title = title
        entry.note = note
        entry.timestamp = Date()
        entry.mood = mood
        
        saveToPersistence()
    }
    
    func saveToPersistence()
    {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error {
            NSLog("Failed to save to persistence: \(error)")
        }
    }
    
    func deleteEntry(on entry: Entry)
    {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistence()
    }
    
}






