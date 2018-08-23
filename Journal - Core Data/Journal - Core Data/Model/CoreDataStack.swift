//
//  CoreDataStack.swift
//  Journal - Core Data
//
//  Created by Lisa Sampson on 8/20/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal - Core Data")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError( "There was an error trying to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            }
            catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
