//
//  CoreDataStack.swift
//  JournalCoreData
//
//  Created by admin on 10/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Let us access the CoreDataStack from anywhere in the app.
    static let shared = CoreDataStack()
    
    // Set up a persistent container
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // Create easy access to the moc (managed object context)
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        do {
            let tasks = try moc.fetch(fetchRequest)
            return tasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
        
    }
}
