//
//  CoreDataStack.swift
//  Journal
//
//  Created by Chad Parker on 4/22/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // makes access to the context easier
    // reminds you to use the context on the main queue
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

extension NSManagedObjectContext {
    static let mainContext = CoreDataStack.shared.mainContext
}
