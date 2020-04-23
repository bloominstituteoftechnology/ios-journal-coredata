//
//  CoreDataStack.swift
//  Journal
//
//  Created by Thomas Dye on 4/22/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // This is a shared instance of the CoreDataStack
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        // "Tasks" needs to be named what the .xcdatamodeld file is named
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_ , error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    // Makes the access to the context faster
    // Reminds you to use the context on the maine queue
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
