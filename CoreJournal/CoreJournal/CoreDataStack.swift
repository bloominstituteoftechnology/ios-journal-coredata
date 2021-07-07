//
//  CoreDataStack.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        // Could be the main or background, it does not matter
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    // Does not initialize until called, stored property NOT computed property, so we can set up once not multiple times
    lazy var container: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        
        let container = NSPersistentContainer(name: appName)
       // let container = NSPersistentContainer(name: "CoreJournal")
        
        // Load the persistent store
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // This should help you remember that the viewContext should be used on the main thread
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

