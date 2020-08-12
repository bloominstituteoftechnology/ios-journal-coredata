//
//  CoreDataStack.swift
//  Journal
//
//  Created by ronald huston jr on 7/12/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {
        
    }
    
    //  stay lazy: only called when needed
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Entry")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("failed to load persistent stores: \(error)")
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
