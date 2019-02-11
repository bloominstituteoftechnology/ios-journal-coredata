//
//  Entry+Convenience.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import CoreData

extension Entry {
    
    convenience init(title: String?, bodyText: String?, timestamp: Date?, identifier: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // Setting up the NSManagedObject (the cored data related) part of the Task object
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
        
    }
}
