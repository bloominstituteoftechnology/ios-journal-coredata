//
//  CoreDataStack.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // LETS US ACCESS THE CoreDataStack FROM ANYWHERE IN THE APP.
    static let shared = CoreDataStack()
    
    // SET UP A PERSISTENT CONTAINER
    lazy var container: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // CREATE EASY ACCESS TO THE MOC (MANAGED OBJECT CONTEXT)
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveToPersistentStore() {
        
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
        
    }
    
}
