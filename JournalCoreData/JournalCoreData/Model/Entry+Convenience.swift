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
    // This computed property allows any managed object to become an EntryRepresentation for sending to Firebase
    var entryRepresentation: EntryRepresentation? {
        guard let mood = mood else { return nil }
        return EntryRepresentation(title: title, timestamp: timestamp, identifier: identifier, bodyText: bodyText, mood: mood)
    }
    
    // This creates a new managed object from raw data
    @discardableResult convenience init(title: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, bodyText: String, mood: String = "😐", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    // This creates a managed object from an EntryRepresentation object (which comes from Firebase)
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
