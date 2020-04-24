//
//  CoreDataStack.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Singleton accessor
    static let shared = CoreDataStack()
    
    // Setup the container
    lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Journal") // name of the data model, no need extension
        // stores is how we access data through the container
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persisten stores: \(error)")
            }
        }
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
