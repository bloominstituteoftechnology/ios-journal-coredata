//
//  CoreDataStack.swift
//  Journal
//
//  Created by Hunter Oppel on 4/20/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Singleton
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
