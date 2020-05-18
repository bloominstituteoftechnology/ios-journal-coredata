//
//  CoreDataStack.swift
//  Journal
//
//  Created by Vincent Hoang on 5/18/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import CoreData
import os.log

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                os_log("Failed to load persistent stores: %@", "\(error)")
                return
            }
        }
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
