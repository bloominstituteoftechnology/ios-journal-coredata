//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Julian A. Fordyce on 6/3/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    static let shared = CoreDataStack()
    
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
    
    lazy var container: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "Tasks")
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
