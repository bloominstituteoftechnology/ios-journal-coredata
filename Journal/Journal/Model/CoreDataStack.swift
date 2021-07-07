//
//  CoreDataStack.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    static let shared = CoreDataStack()  //create singleton - managed object
    
    private init() {}
    
    lazy var container: NSPersistentContainer = { // create persistent store and persistant store container - Plural
        let newContainer = NSPersistentContainer(name: "Entries")
        newContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        return newContainer
    }()
    var mainContext: NSManagedObjectContext { // created mamaged object context 
        return container.viewContext
    }
    // fix concurrency
    func save(context: NSManagedObjectContext) throws {
        var saveError: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
                print(error)
            }
        }
        if let saveError = saveError { throw saveError }
    }
}
