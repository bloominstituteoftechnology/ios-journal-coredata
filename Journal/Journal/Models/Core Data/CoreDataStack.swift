//
//  CoreDataStack.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Below we create singleton on the core data stack.  allows everyone to access the exact SAME instance of CoreDataStack.
    
    static let shared = CoreDataStack()
    
    // lazy means the code isn't loaded until the first time it is accessed.  Saves computer resources particularly if you're not sure it will be accessed.
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal") // name of date model goes here.
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // the conduit through which you communicate with the database or coredatastack.
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
