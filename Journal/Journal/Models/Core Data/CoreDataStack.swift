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
    
    //MARK: - Properties
    
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
    
    //MARK: - Context
    
    var mainContext: NSManagedObjectContext {
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container.viewContext
    }
    
    //MARK: - Functions

    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
                
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
}
