//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/28/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    
    // Get the Model Object Context
    let moc = JournalCoreDataStack.shared.mainContext
    
    var entries: [Entry] {
        // Allows any changes to the persistent store to be seen immediately by the user in the TVC
       return loadFromPersistentStore()
    }
    
    // MARK: - CRUD Functions
    
    /* // CRUD functions to:
        1. Create new entity objects
        2. Perform the fetch request on the core data stack's mainContent (must be enclosed in a do try catch block)
        3. Update an entity objects
        4. Delete an entity objects
    */
    
    
    // Function to save the core data stack's mainContext
    // This will bundle the changes that are tracked and managed in the Managed Object Context, mainContext
    func saveToPersistentStore() {
        
        do {
            try moc.save()
        } catch {
            NSLog("Unable to save new entry: \(error)")
        }
    }
    
    // Crud
    func createEntry(title: String, bodyText: String, mood: String) {
        _ = Entry(title: title, bodyText: bodyText, mood: Moods(mood) ?? 1)
        saveToPersistentStore()
    }
    
    // cRud
    func loadFromPersistentStore() -> [Entry] {
        
        // Create a fetch request to return all of the entries
        let fetchRequest : NSFetchRequest<Entry> = Entry.fetchRequest()
        1
         // Use the newly created NSFetchRequest to fetch the Entry objects
        // Ask the Managed Object Context to fetch the entries
        // Fetch returns an array of fetched objects
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching entries from persistent storee \(error)")
            return[]
        }
    }
 
    // crUd
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        
        // Make sure the entry has actually been made
        guard let entryIndex = entries.firstIndex(of: entry) else { return }
        
        // Now get the entry
      //  let currentEntry = entries[entryIndex]
        
        // Got the index now update the entry.  Delete and capture it.
        entries[entryIndex].title = title
        entries[entryIndex].bodyText = bodyText
        entries[entryIndex].mood = mood
        entries[entryIndex].timestamp = Date()
        print(entries[entryIndex])
        saveToPersistentStore()
    }
    
    // cruD
    func delete(delete: Entry) {
        moc.delete(delete)
        saveToPersistentStore()
    }
    
    
//    // MARK: - Private Functions
//
//    private Date()
    
}
