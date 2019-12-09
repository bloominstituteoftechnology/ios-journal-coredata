//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(mood: String = "😭",
                     title: String,
                     timestamp: Date,
                     bodyText: String? = nil,
                     identifier: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = identifier
    }
}
