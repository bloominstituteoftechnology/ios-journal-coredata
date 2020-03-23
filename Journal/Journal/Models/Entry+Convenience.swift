//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

/// Because we choose class define in Tasks.xcdaatamodeld, Task gets generated behind the scenes
extension Entry {
    @discardableResult convenience init(indetifier: String,
                     title: String,
                     bodyText: String? = nil,
                     timestamp: Date? = nil,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}
