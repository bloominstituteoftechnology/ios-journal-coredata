//
//  CoreDataStack.swift
//  Journal
//
//  Created by Zack Larsen on 12/16/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import Foundation
import CoreData


class coreDataStack {
    
    static let shared = coreDataStack()
    
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry") /* the file database */
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext { /* connecting to database, a conduit, fetch or save to database.*/
        return container.viewContext
    }
}

