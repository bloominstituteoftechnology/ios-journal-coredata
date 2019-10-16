//
//  Entry+Convenience.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/15/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😁
    case 😐
    case 🥺
}

extension Entry {

    // In the Entry extension, create a var entryRepresentation: EntryRepresentation computed property. It should simply return an EntryRepresentation object that is initialized from the values of the Entry.
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title,
        let bodyText = bodyText,
        let timestamp = timestamp,
            let mood = mood,
            let identifier = identifier else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
    
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timestamp: Date = Date.init(timeIntervalSinceNow: 0),
                                        identifier: UUID = UUID(),
                                        mood: Mood,
                                        context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
// MARK: New initializer for entryRepresentation
//  Add a new convenience initializer. This initializer should be failable. It should take in an EntryRepresentation parameter and an NSManagedObjectContext. This should simply pass the values from the entry representation to the convenience initializer you made earlier in the project.
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: entryRepresentation.identifier,
                  mood: mood,
                  context: context)
    }
    
}
