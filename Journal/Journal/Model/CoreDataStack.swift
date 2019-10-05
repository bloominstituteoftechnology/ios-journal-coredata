//
//  CoreDataStack.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        
        let container = NSPersistentContainer(name: "Journal")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading core data: \(error)")
            }
        }
        return container
    }()
    
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
