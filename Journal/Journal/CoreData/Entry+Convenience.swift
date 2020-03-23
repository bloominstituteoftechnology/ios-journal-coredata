//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult
    convenience init(title: String,
                     bodyText: String?,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
