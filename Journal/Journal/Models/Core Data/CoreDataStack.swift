//
//  CoreDataStack.swift
//  Journal
//
//  Created by Dahna on 4/20/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //  Singleton - Everyone will get the same shared instance bc of the "static let" no matter where you are
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal") // The name of the container needs to match the name of the Data Model you're going to use/name of your app
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persisten stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

