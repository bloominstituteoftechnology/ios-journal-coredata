//
//  CoreDataStack.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    //step2
    //create a container to hold the stack
    static let container: NSPersistentContainer = {
        //create this container to be run later, when someone asks for it instead of immediately
        let container = NSPersistentContainer(name: "Journal")
        //step 3 tell the container what to do
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //step 4 create the context (MOC)
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    
}




