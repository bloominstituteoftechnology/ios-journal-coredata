//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Cora Jacobson on 8/5/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(), title: String, bodyText: String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
}
