//
//  CoreDataStack.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
            container.loadPersistentStores { (_, error) in
                if let error = error {
                    fatalError("unable to load from persistent Store")
                }
            }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
