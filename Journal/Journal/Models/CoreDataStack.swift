//
//  CoreDataStack.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyrigh/Users/davidwilliams/Development/iOSPT5/Unit2/Homework/ios-journal-coredata/Journal/Journalt © 2020 david williams. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    //kCFBundleNameKey as String
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Journal" as String)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Fail to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

  
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error {
            throw error
        }
    }
}
