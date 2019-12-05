//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}


