//
//  CoreDataStack.swift
//  Journal
//
//  Created by Harmony Radley on 4/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {   // data model 
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { _, error in
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
