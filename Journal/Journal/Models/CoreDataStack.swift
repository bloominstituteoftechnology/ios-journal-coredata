//
//  CoreDataStack.swift
//  Journal
//
//  Created by John Kouris on 9/30/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            print("Error saving context: \(error)")
            mainContext.reset()
        }
    }
    
}
