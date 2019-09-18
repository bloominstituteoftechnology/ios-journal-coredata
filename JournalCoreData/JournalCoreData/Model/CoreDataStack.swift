//
//  CoreDataStack.swift
//  JournalCoreData
//
//  Created by Marc Jacques on 9/16/19.
//  Copyright © 2019 Marc Jacques. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init () { }
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Entry")
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
}
