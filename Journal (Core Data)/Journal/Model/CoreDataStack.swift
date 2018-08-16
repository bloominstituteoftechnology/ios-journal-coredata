//
//  CoreDataStack.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Static means that the property doesn't belong to an instance of a class, but is rather shared by all instances
    // Here, we are using a static property called shared that will store a single CoreDataStack that any piece of code will be able to access by calling CoreDataStack.shared. This is called a singleton
    static let shared = CoreDataStack()
    
    // lazy: will only load the first time you access it. The next time you access this property, it will use what was loaded last time.
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                // Kills the app and returns an error
                fatalError("Failed to load persistent store: \(error)")
            }
        })
        
        // Link parent to child
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // Can only use this on the main queue
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
