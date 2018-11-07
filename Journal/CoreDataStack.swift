//
//  CoreDataStack.swift
//  Journal
//
//  Created by Lotanna Igwe-Odunze on 11/7/18.
//  Copyright © 2018 Lotanna. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error { fatalError("Failed to load persistence stores: \(error)") }
        }
        return container
    }() //End of container
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}//End of CoreDataStack
