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
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error else { fatalError("error loading data")}
        })
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    func saveToPersistentStore() {
        
        do{
            try mainContext.save()
        } catch let error {
            NSLog("erroe saving to perssistent store: \(error)")
            mainContext.reset()
        }
    }
    

    
    
    
    
    
    
    
    
}
