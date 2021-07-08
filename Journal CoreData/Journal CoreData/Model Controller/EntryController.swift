//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    
    /*
    func saveToPersistentStore() {
        do{
           try moc.save()
        }catch{
            NSLog("Error saving managed objects contact \(error)")
        }
        
    }
    
    func loadFromPersistenceStore() -> [Entry]{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do{
            return try moc.fetch(fetchRequest)
        }catch{
            NSLog("error \(error) occured")
            return []
        }
    }
    
    var entries: [Entry]{
        
        return loadFromPersistenceStore()
    }
 
   */
    
    func createEntry(name:String, bodyText: String, mood: String){
        let _ = Entry(name: name, bodyText: bodyText, mood: EntryMood(rawValue: mood)!)
    
    }
    
    func updateEntry(entry: Entry, name: String, bodyText: String, mood:String){
    entry.name = name
    entry.bodyText = bodyText
    entry.timestamp = Date()
    entry.mood = mood

        
    }
    
      func delete(entry: Entry) {
        moc.delete(entry)
        
        
    }
    
}

