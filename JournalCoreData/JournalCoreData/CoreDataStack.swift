//
//  CoreDataStack.swift
//  Tasks
//
//  Created by John Holowesko on 2/13/20.
//  Copyright © 2020 John Holowesko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "Journal")
        newContainer.loadPersistentStores { (_, error) in
            
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return newContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
