//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Jerrick Warren on 11/7/18.
//  Copyright © 2018 Jerrick Warren. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    //MARK: - CRUD
    
    func createEntry(title:String, bodyText:String){
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    
    func updateEntry(entry: Entry, title: String, bodyText: String) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey:"bodyText")
        entry.setValue(Date(), forKey: "timeStamp")
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
func saveToPersistentStore() {
    let moc = CoreDataStack.shared.mainContext
    do {
        try moc.save()
    } catch {
        NSLog("Error savivng managed object context:\(error) to file")
    }
}


    // this will return an array
func loadFromPersistentStore() -> [Entry] {
    //let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    // what is the difference of doing ->
    
    let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
    
    let moc = CoreDataStack.shared.mainContext
    do {
        return try moc.fetch(fetchRequest)
    } catch {
        NSLog("Error fetching tasks: \(error)")
        return []
    }

}

// MARK: - Properties

    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    

}
