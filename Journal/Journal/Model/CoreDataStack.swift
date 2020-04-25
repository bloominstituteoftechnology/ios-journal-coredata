//
//  CoreDataStack.swift
//  Journal
//
//  Created by Bree Jeune on 4/24/20.
//  Copyright © 2020 Young. All rights reserved.
//

import Foundation

import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores  { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

}
