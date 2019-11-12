//
//  CoreDataStack.swift
//  Journal
//
//  Created by Rick Wolter on 11/11/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import Foundation
import CoreData



class CoreDataStack {
    
    
    
    static let shared = CoreDataStack()
  lazy var container: NSPersistentContainer = {
            let container  = NSPersistentContainer(name: "Entries")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to load persistent stores: \(error)")
                }
            }
            return container
        }()
        
        
        var mainContext: NSManagedObjectContext{
            return container.viewContext
        }
        
        
    }
