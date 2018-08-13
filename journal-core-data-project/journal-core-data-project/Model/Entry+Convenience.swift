//
//  Entry+Convenience.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: String = UUID.init().uuidString, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = Date()
        
    }
    
    
}
