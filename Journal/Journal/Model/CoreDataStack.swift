//
//  CoreDataStack.swift
//  Journal
//
//  Created by Breena Greek on 4/22/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // This is a shared instance of the Core Data Stack
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // Makes the access to the context faster
    // Reminds you to use the context on the main queue
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
         
         var error: Error?
         
         // This lets us save any context on the right thread, avoiding concurrency issues.
         context.performAndWait {
             do {
                 try context.save()
             } catch let saveError {
                 error = saveError
             }
         }
         if let error = error {
             throw error
         }
     }
}
