//  Copyright © 2019 Frulwinn. All rights reserved.

import CoreData

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        
        var error: Error?
        context.performAndWait {
            
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    //lazy means upon initialization it is not going to create container until someone is trying to access it
    //stored property runs only 1 time
    lazy var container: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: "journal")
        
        //Load the persistent store
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    //This should help you remember that the viewContext should be used on the main thread
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

