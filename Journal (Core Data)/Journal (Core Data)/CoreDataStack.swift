//
//  CoreDataStack.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "Entries")
        container.loadPersistentStores { (description, error) in
            if let e = error {
                fatalError("Couldn't load the data store: \(e)")
            } else {
                print("\(description)")
            }
        }
        
        mainContext = container.viewContext
    
    }
}

