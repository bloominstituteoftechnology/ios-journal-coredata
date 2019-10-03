//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID.init().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
