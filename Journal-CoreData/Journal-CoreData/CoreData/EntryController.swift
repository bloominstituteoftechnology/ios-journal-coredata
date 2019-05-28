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
    
    var entries: [Entry] {
        // Allows any changes to the persistent store to be seen immediately by the user in the TVC
        loadFromPersistentStore()
    }
    
    // MARK: - Functions
    
    // Function to save the core data stack's mainContext
    // This will bundle the changes that are tracked and managed in the Managed Object Context, mainContext
    func saveToPersistentStore() {
        
    }
    
    /* Function to:
        1. create an NSFetchRequest for Entry objects
        2. Perform the fetch request on the core data stack's mainContent (must be enclosed in a do try catch block)
        3. Return the results of the fetch
        4. Catch and handle any errors and return an empty array
    */
    func loadFromPersistentStore() -> [Entry] {
        
        // NSFetchRequest for Entry objects
        
        // Fetch the Entry objects
//        do {
//            
//        } catch {
//            if let error = error {
//              //  fatalError("Unable to fetch entries from persistent store: \(error)")
//                return []
//            }
//        }
        
        return []
    }
    
    
    
}
