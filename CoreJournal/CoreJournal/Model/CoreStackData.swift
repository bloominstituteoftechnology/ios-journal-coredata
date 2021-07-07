//
//  CoreStackData.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/27/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreJournal")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistence stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
