//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Thomas Dye on 4/22/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String?,
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext) {
        // Set up the NSManagedObject portion of the Task object
        self.init(context: context)
            
        // Assign our unique values to the attributes we created in the data model file
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
            
        }
}
