//
//  CoreDataStack.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/20/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack
{
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entries")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error
            {
                print("There was an error trying to load persistent stores: \(error)" )
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext
    {
        return container.viewContext
    }
}
