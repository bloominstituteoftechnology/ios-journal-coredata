//
//  EntryController.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/21/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

class EntryController
{
    var entries: [Entry]
    {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore()
    {
        let moc = CoreDataStack.shared.mainContext
        
        do
        {
            try moc.save()
        }
        catch
        {
            NSLog("There was an error while saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry]
    {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext

        do
        {
            return try moc.fetch(fetchRequest)
        }
        catch
        {
            NSLog("There was an error while fetching Entries: \(error)")

            return []
        }
    }
    
    func createEntry(title: String, textBody: String)
    {
        let _ = Entry(title: title, bodyText: textBody)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: Date = Date())
    {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry)
    {
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry)
        
        do
        {
            try moc.save()
        }
        catch
        {
            moc.reset()
            
            NSLog("There was an error while saving managed object context: \(error)")
        }
    }
}
