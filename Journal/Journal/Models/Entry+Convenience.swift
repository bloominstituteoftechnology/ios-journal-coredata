//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chris Dobek on 4/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String,
                                           bodyText: String? = nil,
                                           timestamp: Date = Date(),
                                           identifier: UUID = UUID(),
                                           context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

           self.init(context: context)
           self.title = title
           self.bodyText = bodyText
           self.timestamp = timestamp
           self.identifier = identifier
        
       }
}
