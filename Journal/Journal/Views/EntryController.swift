//
//  EntryController.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object data: \(error)")
        }
    }
    
    
    func Create(title: String, bodyText: String, mood: Int16) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)
        
        
        
        let _ = Entry(mood: EntryPriority(rawValue: mood)!, title: title, timestamp: result, bodyText: bodyText)
    
        saveToPersistentStore()
    }
    
    func Update(title: String, bodyText: String, entry: Entry, mood: Int16) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let result = formatter.string(from: date)
        
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = result
        entry.mood = mood
        
        
        saveToPersistentStore()
    }
    
    func Delete(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
    
    
    
}
