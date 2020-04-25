//
//  Journal+Convenience.swift
//  Journal
//
//  Created by Breena Greek on 4/22/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😃"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    @discardableResult convenience init(title: String,
                     bodyText: String,
                     timeStamp: Date = Date(),
                     identifier: UUID = UUID(),
                     mood: Mood,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
}
