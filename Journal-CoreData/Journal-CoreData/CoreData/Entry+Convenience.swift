//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(identifier: String,
                     title: String,
                     timestamp: Date,
                     bodyText: String,
                     context: NSManagedObjectContext = JournalCoreDataStack.shared.mainContext) {
        
        // A managed context MUST be provided when a Core Data object is initialized.
        // A Core Data Object can not exsit outside of a Managed Object Context
        // The main context in Core Data is viewContext
        
        // Call the Entry class' initializer that takes in an NSManagedObjectContext
        self.init(context: context)
        
        // Set the value of attributes defined in the data model
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
    }
    
}
