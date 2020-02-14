//
//  CoreDataStack.swift
//  Journal
//
//  Created by Gerardo Hernandez on 2/12/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData

//Singleton
//4 fours of Core Data Stack
class CoreDataStack {
    
    //MARK: Properties
    static let shared = CoreDataStack()
    
    private init () {}
    
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "Entry")
        newContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Faied to load persistent stores: \(error)")
            }
        }
        return newContainer
    } ()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
