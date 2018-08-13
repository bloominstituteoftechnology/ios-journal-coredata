//
//  Entry+Convenience.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
    
    convenience init(title: String,
                     identifier: String,
                     timestamp: Date,
                     bodyText: String,
                     managedObjectContext: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        
        self.title = title
        self.identifier = identifier
        self.timestamp = timestamp
        self.bodyText = bodyText
        
    }
    
}
