//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = "entry", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
