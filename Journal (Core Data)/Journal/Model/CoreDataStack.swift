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
    
    // instance of CoreDateStack that can be shared through the app?
    static let shared = CoreDataStack()
    
    // lazy: will only load the first time you access it
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                // Kills the app and returns an error
                fatalError("Failed to load persistent store: \(error)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
