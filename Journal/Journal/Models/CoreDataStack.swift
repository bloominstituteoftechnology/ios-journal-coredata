//
//  CoreDataStack.swift
//  Journal
//
//  Created by brian vilchez on 9/16/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("error loading data: \(error)")}
        })
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return container.viewContext
    }()
    

    
    
    
    
    
    
    
    
}
