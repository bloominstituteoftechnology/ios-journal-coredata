//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String,
                           title: String,
                           timestamp: Date,
                           bodyText: String,
                           context: NSManagedObjectContext) {
           
           //set up the NSManagaedObject portion of the task object
           self.init(context: context)
           
           //assign our unique values to the attributes we created in the data model file
           self.identifier = identifier
           self.title = title
           self.timestamp = timestamp
           self.bodyText = bodyText
           
           
       }
}
