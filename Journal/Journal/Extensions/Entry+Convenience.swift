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
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timestamp = timestamp,
            let identifier = identifier,
            let mood = mood else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
    
    @discardableResult convenience init(title: String, bodyText: String?, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: String = "😀", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: mood.rawValue, context: context)
    }
}
