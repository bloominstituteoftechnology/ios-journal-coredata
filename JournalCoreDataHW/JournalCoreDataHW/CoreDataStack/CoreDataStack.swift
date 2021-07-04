//
//  CoreDataStack.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Failed to laod the persistent store: \(error)")
            }
        }
        //This is required for the viewContext ( ie. the main context ) to be updated with changes saved in a background context. In this case, the viewContext's parent is the persistent store coordinator, not another context.
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    //A generic function to save any context we want ( main or background ).
    func save(context: NSManagedObjectContext) throws { //throws because of the do try catch we will add
        var error: Error? //placeholder for the potential error. We will set its value with the error from the do try catch block
        
        //#1. Rule of core data: Don't use core data objects outside of a perform() block. i.e. performAndWait ( the equivalent to dispatchQueue.main.asynch )
        do {
            try context.save()
        } catch let saveError {
            print("Error saving to moc: \(saveError.localizedDescription)")
            error = saveError
        }
        
        // if there was an error, throw the function
        if let error = error {
            throw error
        }
    }
}




