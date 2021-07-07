//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Alex Shillingford on 8/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
