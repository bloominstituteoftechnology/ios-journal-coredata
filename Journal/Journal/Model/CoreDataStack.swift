//
//  CoreDataStack.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
       let newContainer = NSPersistentContainer(name: "Journal")
        newContainer.loadPersistentStores { _, error in
            guard error == nil else{
                fatalError("Failed to load persistent stores: \(error!)")
            }
        }
        
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        return newContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        //could be the main contect or a background context
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
