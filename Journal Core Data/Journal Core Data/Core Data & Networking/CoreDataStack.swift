//
//  CoreDataStacj.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "JournalCoreData")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("could not load the data store: \(error)")
            } else {
                print("\(description)")
            }
        }
        mainContext = container.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
    }
}

