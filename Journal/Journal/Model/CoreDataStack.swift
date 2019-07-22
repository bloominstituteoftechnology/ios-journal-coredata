//
//  CoreDataStack.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: kCFBundleNameKey as String)
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                
                // Crashes app and logs the nature of the error.
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    // This should help you remember to use the viewContext on the main thread only.
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    
    
}
