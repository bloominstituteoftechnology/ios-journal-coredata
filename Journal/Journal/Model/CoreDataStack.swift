//
//  CoreDataStack.swift
//  Journal - Day 2
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry" )
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error)")
            }
        }
        return container }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
