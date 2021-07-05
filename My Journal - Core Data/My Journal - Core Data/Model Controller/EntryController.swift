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
    
    
   // MARK: - CRUD methods
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
   
    func create(title:String,bodyText:String,identifier: String, mood:String, date: Date) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: date, identifier: identifier,context: CoreDataStack.shared.mainContext, mood: mood)
        saveToPersistentStore()
    }
    
    
    func update(with newTitle : String, bodyText: String,mood: String, entry: Entry) {
        DispatchQueue.main.async {
            entry.title = newTitle
            entry.bodyText = bodyText
            entry.mood = mood
            entry.timestamp = Date()
        }
      
        saveToPersistentStore()
    
    }
   
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
}
