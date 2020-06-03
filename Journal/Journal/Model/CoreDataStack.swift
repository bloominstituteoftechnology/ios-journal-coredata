//
//  CoreDataStack.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error{
                fatalError("Failed to lead persistence stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
