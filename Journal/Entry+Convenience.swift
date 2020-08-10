//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dojo on 8/5/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit
import CoreData

enum Mood: String, CaseIterable {
case happy = "😀"
case neutral = "😐"
case sad = "☹️"
}

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        bodyText: String?,
                                        timestamp: Date,
                                        mood: Mood,
                                        title: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        self.title = title
    }
}
