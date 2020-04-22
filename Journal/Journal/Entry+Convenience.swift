//
//  Entry+Convenience.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                        title: String,
                        bodyText: String?,
                        timestamp: Date,
                        context: NSManagedObjectContext) {
           
           self.init(context: context)
           
           self.identifier = identifier
           self.title = title
           self.bodyText = bodyText
           self.timestamp = timestamp
       }
}
