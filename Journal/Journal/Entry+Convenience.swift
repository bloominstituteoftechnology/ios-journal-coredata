//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Thomas Sabino-Benowitz on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😾, 😺, 😸
}

extension Entry {
    convenience init(bodyText: String? = nil,
                     identifier: String? = nil,
                     timestamp: Date? = Date(),
                     title: String,
                     mood: Mood = .😺,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}
