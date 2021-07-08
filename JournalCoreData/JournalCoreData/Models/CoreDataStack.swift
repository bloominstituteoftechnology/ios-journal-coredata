//
//  CoreDataStack.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "JournalCoreData")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
