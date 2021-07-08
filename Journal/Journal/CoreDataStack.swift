//
//  CoreDataStack.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var container: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failerd to load persistent stores:\(error)")
            }
            
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}


