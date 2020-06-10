//
//  CoreDataStack.swift
//  Journal
//
//  Created by Ian French on 6/3/20.
//  Copyright © 2020 Ian French. All rights reserved.
//


import Foundation
import CoreData

class CoreDataStack {
    // Static makes it a class property
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
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

