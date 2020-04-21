//
//  CoreDataStack.swift
//  Journal
//
//  Created by Shawn James on 4/20/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Singleton
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entries")
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
