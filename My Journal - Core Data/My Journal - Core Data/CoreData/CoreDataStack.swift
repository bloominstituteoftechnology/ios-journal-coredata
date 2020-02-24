//
//  CoreDataStack.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack
{
    
    
    static let shared = CoreDataStack()
    
    lazy var container : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "My Journal - Core Data")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load container : \(error)")
            }
        }
        return container
    }()
    
    var mainContext : NSManagedObjectContext {
        return container.viewContext
    }
    
}
