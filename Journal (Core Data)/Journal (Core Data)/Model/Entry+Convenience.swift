//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp =  timestamp
        self.identifier = identifier
    }
}
