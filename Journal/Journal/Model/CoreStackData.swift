//
//  CoreStackData.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // create singleton of an instance of CoreDataStack
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        // create container the name of the model
        let container = NSPersistentContainer(name: "Entry" as String)
        
        // load the saved data
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load stored data \(error)")
            }
        })
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
