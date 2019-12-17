//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Zack Larsen on 12/16/19.
//  Copyright © 2019 Zack Larsen. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: String, context: NSManagedObjectContext = coreDataStack.shared.mainContext) {
        self.init(context: context)
            self.title = title
            self.bodyText = bodyText
            self.timestamp = timestamp
            self.identifier = identifier
    }
}

