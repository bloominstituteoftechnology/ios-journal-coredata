//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Shawn James on 4/20/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: String,
                                        title: String,
                                        timestamp: Date,
                                        bodyText: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
    }
}
