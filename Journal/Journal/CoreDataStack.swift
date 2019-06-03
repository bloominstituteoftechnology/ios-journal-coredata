//
//  CoreDataStack.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
            
        }
        
        return container
    }()
    
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
