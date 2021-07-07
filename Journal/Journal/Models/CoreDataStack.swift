//
//  CoreDataStack.swift
//  
//
//  Created by Scott Bennett on 9/24/18.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
