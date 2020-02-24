//
//  EntryController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreData

class EntryController
{
    
    var entries: [Entry] {
        get {
             loadFromPersistentStore()
        } set {
            self.entries = newValue
        }
          
       }
       
    
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest:  NSFetchRequest<Entry> = Entry.fetchRequest()
               do {
                   return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
               } catch {
                   NSLog("Error fetching tasks: \(error)")
                   return []
               }
    }
    
   
    func create(title:String,bodyText:String,identifier: String, date: Date) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: date, identifier: identifier, context: CoreDataStack.shared.mainContext)
        saveToPersistentStore()
    }
    
    
    func update(with title : String, bodyText: String, entry: Entry) {
        guard let index = entries.firstIndex(of: entry) else { return }
        
      
        entry.title = title
        entry.bodyText = bodyText
        
        entries.remove(at: index)
        entries.insert(entry, at: index)
    }
    
    
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
