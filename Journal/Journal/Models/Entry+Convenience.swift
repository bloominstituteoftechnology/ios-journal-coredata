//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    /// These need to match the database. i.e. Default value in database model.
    /// Same order as segmented control
    case happy = "😄"
    case neutral = "😐"
    case sad = "☹️"
}

/// Because we choose class define in Tasks.xcdaatamodeld, Task gets generated behind the scenes
extension Entry {
    @discardableResult convenience init(identifier: String,
                     title: String,
                     bodyText: String? = nil,
                     timestamp: Date? = nil,
                     mood: Mood = .neutral,
                     context: NSManagedObjectContext) {
        /// Magic happens here
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
}
