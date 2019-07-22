//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String = "1", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // Add the "clay" so we can sculpt it into our own unique object.
        // Setting up the NSManagedObject part of the class.
        self.init(context: context)
        
        // Sculpt the unique parts of the Task class (name and notes)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        
    }
    
    
    
    
}
