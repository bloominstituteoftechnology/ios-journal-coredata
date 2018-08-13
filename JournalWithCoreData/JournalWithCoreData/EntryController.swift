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
    var entries: [Entry] = []
    {
        didSet
        {
            loadFromPersistentStore()
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
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp:Date = Date())
    {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
        do
        {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        }
        catch
        {
            NSLog("Error saving managed object context: \(error)")
        }
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
