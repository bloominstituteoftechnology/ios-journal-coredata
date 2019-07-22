//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String?, timestamp: Date = Date(), identifier: String = "id", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up NSManagedObject part of the class
        self.init(context: context)
        
        // Set up the unique parts of the Task class
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
