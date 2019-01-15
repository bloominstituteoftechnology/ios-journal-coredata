//
//  Entry+Convience.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/14/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date.init(), identifier: String = UUID().uuidString, entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Entry", in: CoreDataStack.shared.mainContext)!, insertInto context: NSManagedObjectContext?) {
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
