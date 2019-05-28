//
//  JournalCoreDataStack.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

class JournalCoreDataStack {
    
    static let shared = JournalCoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        // Create a persistent store
        let container = NSPersistentContainer(name: "Entry")
        
        // Load the persistent stores
        container.loadPersistentStores { (_, error) in
            
            // If there is an error fatal out
            if let error = error {
                fatalError("Error loading Core Data stores: \(error)")
            }
            
        } // container
        
        return container
            
    }()
    
}
