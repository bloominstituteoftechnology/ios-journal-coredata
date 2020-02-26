//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "😀"
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), mood: String, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
}
