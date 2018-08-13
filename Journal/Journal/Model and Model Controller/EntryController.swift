//
//  EntryController.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

class EntryController{
    //MARK: - CRUD Methods
    func create(withTitle title: String, bodyText text:String? = nil){
        let _ = Entry(title: title, bodyText: text)
        saveToPersistentStore()
    }
    
    func update(forEntry entry: Entry, withTitle title: String, bodyText text:String){
        entry.title = title
        entry.bodyText = text
        entry.timeStamp = Date()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    //MARK: - Networking
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do{
        try moc.save()
        } catch {
            NSLog("Trouble saving: \(error)")
            moc.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry]{
        //creates a fetch request that is specific to Entry
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        let loadedEntries:[Entry]
        
        do {
            loadedEntries = try moc.fetch(request)
        } catch {
            NSLog("Error loading from persistent store: \(error)")
            return [Entry]()
        }
        return loadedEntries
    }
    
    //MARK: - Properties
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
}
