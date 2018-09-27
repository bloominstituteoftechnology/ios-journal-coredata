//
//  CoreDataStack.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // First create an instance of CoreDataStack
    static let shared = CoreDataStack()
    
    // Then create a lazy NSPersistentContainer instance.
    // We wil modify it so make it variable
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer (name: "Journal CoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
