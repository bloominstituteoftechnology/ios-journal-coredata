//
//  EntryController.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func create(mood: EntryMood, title: String, bodyText: String?) {
        
        let capitalizedTitle = title.capitalizingFirstLetter()
        let _ = Entry(mood: mood,
                      title: capitalizedTitle,
                      bodyText: bodyText)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func update(entry: Entry,
                mood: String,
                title: String,
                bodyText: String,
                timestamp: Date = Date()) {
        entry.mood = mood
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving updated entry \(error)")
        }
    }
    
    func delete(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving deleted entry \(error)")
        }
    }

}

