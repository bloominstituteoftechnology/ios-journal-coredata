//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Josh Kocsis on 6/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
@discardableResult convenience init(identifier: String? = nil,
                                    title: String?,
                                    bodyText: String?,
                                    timestamp: Date? = Date(timeIntervalSince1970: 1480134638.0),
                                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    self.init(context: context)
    self.identifier = identifier
    self.title = title
    self.bodyText = bodyText
    self.timestamp = timestamp
    }
}
