//
//  CoreDataStack.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
}
