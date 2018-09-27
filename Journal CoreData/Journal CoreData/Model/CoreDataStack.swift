//
//  CoreDataStack.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // First create an instance of CoreDataStack
    static let shared = CoreDataStack()
    
    // Will use this instead of saveToPersistence()
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        
        var error: Error? // For thows function will need an optional Error
        
        // This performs given code inside the context's queue
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    // Then create a lazy NSPersistentContainer instance.
    // We wil modify it so make it variable
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer (name: "Journal CoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true // Parent - Child
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
