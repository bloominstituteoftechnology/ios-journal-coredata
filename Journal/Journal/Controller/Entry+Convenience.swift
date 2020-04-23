//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String,
                        title: String,
                        bodyText: String,
                        timestamp: Date,
                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
           
           // Set up the NSManagedObject portion of the Task object
           self.init(context: context)
           
           // Assign our unique values to the attributes we created in the data model file
           self.identifier = identifier
           self.title = title
           self.bodyText = bodyText
           self.timestamp = timestamp
    }
}
