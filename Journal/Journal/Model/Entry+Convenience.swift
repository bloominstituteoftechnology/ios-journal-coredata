//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bronson Mullens on 6/3/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String,
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
}
