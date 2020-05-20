//
//  CoreDataStack.swift
//  Journal
//
//  Created by Harmony Radley on 5/18/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // have to have a way to access coredatastack in our project...
    // singleton - a single object to  access this type anywhere in the project.
    static let shared = CoreDataStack()
    
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        //2. tells the container what kinds of data are in there. Gives it an index. knows how to find information it needs, when it goes to fetch or save that data. Needs to know where to put things.
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // if I want to get data from the data base, or save data to the database, you have to do it through a context.
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
