//
//  CoreDataStack.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: MODELNAME)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    //MARK: Update
    /**
     Saves whatever changes are in the mainContext
     */
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            mainContext.reset()
            NSLog("Saving Task failed with error: \(error)")
        }
    }
    
}
