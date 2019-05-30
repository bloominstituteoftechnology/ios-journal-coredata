//
//  CoreDataStack.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistant stores: \(error)")
            }
        })

        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {}
}
