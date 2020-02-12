//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = Date().description, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}

extension Entry {
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
