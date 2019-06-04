//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "Entry")
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
