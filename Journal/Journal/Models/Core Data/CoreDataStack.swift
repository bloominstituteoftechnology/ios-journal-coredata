//
//  CoreDataStack.swift
//  Journal
//
//  Created by Kelson Hartle on 5/17/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    //o
    
    //taking a type and creating an instance (singelton)
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
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

}
