//
//  CoreDataStack.swift
//  Journal
//
//  Created by Alex Rhodes on 9/16/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {
        
    }
    
    // lazy doesn't initialize upone class initialization, it is only called when needed
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Core sata was unable to load persistence stores: \(error)")
            }
        })
        
        return container
    }()
    
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("error saving context: \(error)")
            mainContext.reset()
        }
    }
}
