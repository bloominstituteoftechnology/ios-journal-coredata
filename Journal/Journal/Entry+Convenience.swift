//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/18/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import CoreData

extension Entry {
    
    convenience init(name: String, bodyText: String, timestamp: Date, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = name
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
