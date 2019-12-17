//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import CoreData
import Foundation

enum EntryMood: String {
    case happy = "😀"
    case sad = "☹️"
    case santa = "🎅🏽"
    
    static var allMoods: [EntryMood] {
        return [.happy, .sad, .santa]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: String = "😀", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
}
