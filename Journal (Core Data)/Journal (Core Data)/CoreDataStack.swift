//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 13/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack
{
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer =
    {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if let error = error
            {
                fatalError("Failed to load persistence store: \(error)")
            }
        })
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext
    {
        return container.viewContext
    }
}















