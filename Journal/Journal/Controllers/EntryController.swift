//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
   
    
    // MARK: - Properties
    
    let MC = CoreDataStack.shared.mainContext
    
    /*
     var entries: [Entry] {
        loadFromPersistentStore()
    }
    */
    

    
    // MARK: - Methods
    
    func saveToPersistentStore() {
    do {
        try MC.save()
    } catch {
        NSLog("Error saving managed object context: \(error)")
        }
    }
    
    /*
     func loadFromPersistentStore() -> [Entry] {
        let fetch: NSFetchRequest<Entry> = Entry.fetchRequest()
        do{
            return try MC.fetch(fetch)
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
   */
    
    // MARK: - CRUD
    
    // CREATE
    func create(title: String, mood: Mood, timeStamp: Date, identifier: String, bodyText: String) {
        let  _ = Entry(title: title, timeStamp: timeStamp, identifier: identifier, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    // UPDATE
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    
    // DELETE
    
    func delete(for entry: Entry) {
        MC.delete(entry)
        saveToPersistentStore()
    }
}

