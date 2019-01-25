//
//  CoreDataStack.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    static let shared = CoreDataStack()
    let mainContext: NSManagedObjectContext
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Journal: Core Data")
        container.loadPersistentStores { (description, error) in
            if let e = error {
                fatalError("Hey for whatever reason I couldn't load the data store. \n\(e)")
            } else {
                print (description)
            }
        }
        mainContext = container.viewContext
    }
}
