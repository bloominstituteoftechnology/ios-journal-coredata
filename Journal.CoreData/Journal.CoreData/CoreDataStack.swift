//
//  CoreDataStack.swift
//  Journal.CoreData
//
//  Created by beth on 2/24/20.
//  Copyright © 2020 elizabeth wingate. All rights reserved.
//


import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    lazy var container: NSPersistentContainer = {
        //the name below shouldmatch the filename of the xcdatamodeld file exactly (minus the extentsion)
     let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { _, error in
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
