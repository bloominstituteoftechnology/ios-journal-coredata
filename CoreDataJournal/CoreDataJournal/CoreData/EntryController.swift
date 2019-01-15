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
    
//    func loadFromPersistentStore()-> [Entry]{
//
//        // this code will run every time you access the entries property
//        // would be must better if we fetched once and then only fetched again
//        // when there were changes
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching entries: \(error)")
//            return []
//        }
//    }
    
    func createEntry(title: String, mood: String, bodyText: String?){
        
        _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, mood: String, bodyText: String?){
       
        entry.bodyText = bodyText
        entry.mood = mood
        entry.title = title

        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
}
