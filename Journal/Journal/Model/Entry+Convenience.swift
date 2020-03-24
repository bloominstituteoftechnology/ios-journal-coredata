//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult
    convenience init(title: String,
                     bodyText: String?,
                     mood: Mood = .neutral,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    var mood: Mood {
        get {
            return Mood(rawValue: self.moodString ?? "") ?? .neutral
        }
        set {
            self.moodString = newValue.rawValue
        }
    }
}
