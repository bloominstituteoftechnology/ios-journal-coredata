//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/14/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

enum JournalMood: String, CaseIterable {
    case sad = "☹️"
    case normal = "😐"
    case happy = "🙂"
}

extension Entry {
    @discardableResult convenience init(title: String, mood: JournalMood, bodyText: String, timestamp: Date? = Date(), identifier: String? = "", context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
