//
//  CoreDataStack.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // singleton
    static let shared = CoreDataStack()
    
    // "Lazy" will not run any of the this code unless we actually call this property
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load PersistentStores: \(error)")
            }
        }
        return container
    }()
    
    // review this subject
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
