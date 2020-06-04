//
//  CoreDataStack.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/2/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
   // Static makes it a class property instead of an instance property
   // Singleton

    static let shared = CoreDataStack()
    // lazy = not going to create until someone uses
    lazy var container: NSPersistentContainer = {
         // make sure container name is the same as the xcdatamodeld name
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
