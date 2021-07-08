//
//  CoreDataStack.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    
    static let shared = CoreDataStack()
    
    //lazy variables dont takes in memory until tehay are being called
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error{
                print("there was an \(error)")
            }
        })
        return container
    }()
    
    //
    var mainContext: NSManagedObjectContext{
        return container.viewContext
    }
    
}
