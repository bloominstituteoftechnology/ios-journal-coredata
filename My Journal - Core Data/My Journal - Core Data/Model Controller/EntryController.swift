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
    
    // MARK: - Computed Property
    var entries: [Entry] {
            loadFromPersistentStore()
     
       }
       
    
    
    
   // MARK: - CRUD methods
    
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
    
    
    func update(with newTitle : String, bodyText: String, entry: Entry) {
        DispatchQueue.main.async {
            entry.title = newTitle
            entry.bodyText = bodyText
            entry.timestamp = Date()
        }
      
        saveToPersistentStore()
    
    }
   
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
}
