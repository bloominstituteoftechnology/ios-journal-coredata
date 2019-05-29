//
//  EntryController.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    //commenting out so that we can use the nsfrc
//    var entries: [Entry] {
//        //This will allow any changes to the persistent store to become immediately visible to the user when accessing this array, like in the talbe view showing list of entries.
//        return loadFromPersistentStore()
//    }
    
    func createEntry(title: String, bodyText: String, mood: String){
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newBodyText: String, newTimestamp: Date, newMood: String){
        entry.title = newTitle
        entry.bodyText = newBodyText
        entry.timestamp = newTimestamp
        entry.mood = newMood
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch  {
            print("Error in the saving to persistent store function: \(error.localizedDescription)")
        }
    }
    
    //commenting out so that we can use the nsfrc
//    func loadFromPersistentStore() -> [Entry] {
//        let moc = CoreDataStack.shared.mainContext
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        do {
//            let results = try moc.fetch(fetchRequest)
//            return results
//        } catch  {
//            print("Error with in the load from persistent store function: \(error.localizedDescription)")
//        }
//        return []
//    }
}
