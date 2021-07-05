//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by admin on 10/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date, identifier: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
}
