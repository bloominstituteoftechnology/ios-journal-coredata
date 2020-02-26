//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Enrique Gongora on 2/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😄"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let mood = mood else { return nil }
        return EntryRepresentation(title: title, timestamp: timestamp, identifier: identifier, bodyText: bodyText, mood: mood)
    }
    
    @discardableResult convenience init(title: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, bodyText: String, mood: String = "😐", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let title = entryRepresentation.title, let bodyText = entryRepresentation.bodyText, let timestamp = entryRepresentation.timestamp, let identifierString = entryRepresentation.identifier else { return nil }
        self.init(title: title,
                  timestamp: timestamp,
                  identifier: identifierString,
                  bodyText: bodyText,
                  mood: entryRepresentation.mood,
                  context: context)
    }
}
