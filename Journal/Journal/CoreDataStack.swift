//
//  CoreDataStack.swift
//  Journal
//
//  Created by Victor  on 5/29/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JournalModel")
        container.loadPersistentStores(completionHandler: { _, error  in
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
