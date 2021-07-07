//
//  CoreDataStack.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

// Contain all of the setup of the NSPersistentContainer
class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        // Give the container the name of the data model file
        let container = NSPersistentContainer(name: "Entry")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        
        return container
    }()
    
    // This should help you remember to use the viewContext on the main queue only.
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
