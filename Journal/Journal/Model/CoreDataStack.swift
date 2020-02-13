//
//  CoreDataStack.swift
//  Journal
//
//  Created by Eoin Lavery on 13/02/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    
    static let shared: CoreDataStack = CoreDataStack()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "Entry")
        
        newContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error when loading CoreData Persistent store: \(error)")
            }
        }
        
        return newContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
