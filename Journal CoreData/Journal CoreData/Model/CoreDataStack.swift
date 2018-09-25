//
//  CoreDataStack.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData

class  CoreDataStack {
    
    static let shared = CoreDataStack()
    
     lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal_CoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                NSLog("Error occured while loading Pesersistence: \(error)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext{
        return container.viewContext
    }
    
}
