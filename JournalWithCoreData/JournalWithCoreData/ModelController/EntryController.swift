//
//  EntryController.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

class EntryController
{
    var entry: Entry?
    var entries: [Entry]
    {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore()
    {
        do
        {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            print("save")
        }
        catch
        {
            NSLog("Error saving managed object context: \(error)")
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
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String)
    {
        let _ = Entry(title: title, bodyText: bodyText)
        print(title, bodyText)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: NSDate = NSDate())
    {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp as Date
        print(title, bodyText)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry)
    {
        let entry = entry
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do
        {
            try moc.save()
        }
        catch
        {
            moc.reset()
        }
    }
    
    
    
    
    
}
