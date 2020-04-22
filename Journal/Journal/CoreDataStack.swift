//
//  CoreDataStack.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
   
        let container = NSPersistentContainer(name: kCFBundleNameKey as String)
        container.loadPersistentStores { (_, error) in
            if let error = error {
            fatalError("Fail to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
