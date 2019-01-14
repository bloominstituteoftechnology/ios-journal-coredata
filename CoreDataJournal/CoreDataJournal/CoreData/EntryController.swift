//
//  EntryController.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntryController {
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
    }
    
    func loadFromPersistentStore()-> [Entry]{
       
        // this code will run every time you access the entries property
        // would be must better if we fetched once and then only fetched again
        // when there were changes
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching entries: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String?){
        
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func updateEntry(uuid: UUID){
       
        
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func deleteEntry(title: String, bodyText: String?){
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(<#T##object: NSManagedObject##NSManagedObject#>)
        
        saveToPersistentStore()
    }
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
}
