//
//  CoreDataStack.swift
//  Journal
//
//  Created by Jordan Christensen on 9/17/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {
        
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entries")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistant stores: \(error)")
            }
        })
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
