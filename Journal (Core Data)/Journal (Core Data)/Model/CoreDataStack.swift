//
//  CoreDataStack.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

// Step 1: Create Managed Object Model
class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    // Step 2: Create Persistent Store Manager and Persistent Store
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "Journal (Core Data)")
        newContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return newContainer
    }()
    
    // Step 3: Create Managed Object Context
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
