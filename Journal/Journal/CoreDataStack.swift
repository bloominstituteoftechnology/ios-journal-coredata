//
//  CoreDataStack.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "Entry")
        newContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Failed to load persistent stores: \(error!)")
            }
        }
        return newContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveToPersistenceStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
    }
}
