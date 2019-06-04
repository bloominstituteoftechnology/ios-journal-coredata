//
//  CoreDataStack.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { (_, error) in
            
            if let error = error {
                fatalError("Failded to load persistent Stores: \(error)")
            }
        }
        
        
        
        return container
        
        
    } ()
    
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
}

}
