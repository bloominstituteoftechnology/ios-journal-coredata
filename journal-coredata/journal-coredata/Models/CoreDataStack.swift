//
//  CoreDataStack.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { _, error in
            if let error = error {
                NSLog("Error loading data: \(error)")
            }
        }
        return container
    }()
    
    var mainContexta: NSManagedObjectContext {
        container.viewContext
    }
}
