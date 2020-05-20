//
//  Entry+Convenience.swift
//  Journal
//
//  Created by ronald huston jr on 5/18/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😀"
    case neutral = "😐"
    case sad = "😞"
}

extension Entry {
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date,
                                        identifier: String,
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
