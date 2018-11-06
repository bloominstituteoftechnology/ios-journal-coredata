//
//  EntryController.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        //let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
            
            
        } catch {
            NSLog("Error fetching \(error)")
            return []
            
        }
        
    }
    
    
    func Create(title: String, bodytext: String ){
        
        let _ = Entry(title: title, bodytext: bodytext)
        saveToPersistentStore()
        
    }
    
    func Update(entry: Entry, title: String, bodytext: String ) {
        entry.title = title
        entry.bodytext = bodytext
        entry.timestamp = Date()
        saveToPersistentStore()
        
    }
    
    
    
    func Delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
}
