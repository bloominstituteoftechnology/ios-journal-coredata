//
//  CoreDataStack.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = { // won't run until we ask for it
        let container = NSPersistentContainer(name: "Journal") // MUST MATCH XCDATAMODELD FILENAME
        container.loadPersistentStores { (description, error) in
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
