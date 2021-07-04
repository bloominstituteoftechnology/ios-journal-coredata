//
//  CoreDataStack.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
//step 1
import CoreData

class CoreDataStack {
    //step2
    //create a singleton
    static let shared = CoreDataStack()
    
    //step 3: create a container to hold the stack
    let container: NSPersistentContainer = {
        //create this container to be run later, when someone asks for it instead of immediately
        let container = NSPersistentContainer(name: "Journal")
        //step 4 tell the container what to do
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    //step 5 create the context (MOC)
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) throws {
        var error: Error?
        
        do {
            try context.save()
        } catch let saveError {
            print("Error saving the context: \(saveError.localizedDescription)")
            error = saveError
        }
        
        if let error = error {
            throw error
        }
    }
}
