//
//  CoreDataStack.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //this is a shared instance of the core data stack
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        //name = KCFBundleNameKey as String
      let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistence stores: \(error)")
            }
        }
        return container
    }()
    
    
    //Makes the access to the context faster
    //remind you to use the context on the main queue
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
