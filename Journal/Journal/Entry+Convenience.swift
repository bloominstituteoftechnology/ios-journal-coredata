//
//  Entry+Convenience.swift
//  Journal
//
//  Created by ronald huston jr on 5/18/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date,
                                        identifier: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
