//
//  CoreDataStack.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

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
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
