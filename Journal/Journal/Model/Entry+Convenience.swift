//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import CoreData

extension Entry {
    
    convenience init (title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        (self.title, self.bodyText, self.timestamp, self.identifier) = (title, bodyText, timestamp, identifier)
    }
}
