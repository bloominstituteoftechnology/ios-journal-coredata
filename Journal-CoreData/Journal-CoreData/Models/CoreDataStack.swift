//
//  CoreDataStack.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/16/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal-CoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
//    func saveToPersistentStore() {
//        do {
//            try mainContext.save()
//        } catch {
//            NSLog("Error saving context: \(error)")
//            mainContext.reset()
//        }
//    }
    
    // create a save(context: NSManagedObjectContext) method in your CoreDataStack
    // call .performAndWait on the context that is passed in, then save the same context.
    // Handle any potential errors.
    func save(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}
