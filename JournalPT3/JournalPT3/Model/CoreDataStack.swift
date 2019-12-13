//
//  CoreDataStack.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack { // singelton pattern (considered an anti-pattern) - only one instance of this class (bad for testing)
    static let shared = CoreDataStack() // within the class, creating a version of the class and setting it to a property
    
    lazy var container: NSPersistentContainer = { // lazy variable - this will not be called until it is actually used
        let newContainer = NSPersistentContainer(name: "Entry") // has to be the name of the Data Model
        newContainer.loadPersistentStores { (_, error) in
            guard error == nil else { // recommended use of guard because the compiler will force you to return or throw
                fatalError("Failed to load persistent stores: \(error!)")
            }
        }
        
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        return newContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws  {
        
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
