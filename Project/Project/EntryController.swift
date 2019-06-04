//
//  EntryController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistenStore()
    }

    func saveToPersistenStore() {
    
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        }catch {
            print("Error saving managed object context: \(error)")
        }
    
    }
    
    func loadFromPersistenStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
            
        } catch  {
            NSLog("Error fetching entry: \(error)")
            return []
        }
    }
    
    
    
    
  
    
    func createEntry(title: String, bodyText: String) {
       
       let _ = Entry(title: title, bodyText: bodyText)
        
        saveToPersistenStore()
    
}
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        saveToPersistenStore()
        }
    
    func delete(delete: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(delete)
        saveToPersistenStore()
    }
    
    
    
    
}



