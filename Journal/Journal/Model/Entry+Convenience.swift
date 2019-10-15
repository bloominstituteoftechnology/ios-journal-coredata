//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Isaac Lyons on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

enum EntryMood: String, CaseIterable {
    case angry = "😤"
    case happy = "🥳"
    case mindBlown = "🤯"
}

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood, identifier: String = "", context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        self.identifier = identifier
    }
}
