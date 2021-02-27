//
//  Entry + Convenience.swift
//  Journal
//
//  Created by James McDougall on 2/26/21.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     bodyText: String? = nil,
                     timeStamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
}
