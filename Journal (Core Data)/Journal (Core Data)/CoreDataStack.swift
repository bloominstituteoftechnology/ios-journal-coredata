//
//  CoreDataStack.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext  {
        return container.viewContext
    }
  
    
}

