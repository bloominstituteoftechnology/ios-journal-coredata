//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😀"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timestamp = timestamp,
            let mood = mood,
            let identifier = identifier,
            let bodyText = bodyText else { return nil }
        
        return EntryRepresentation(identifier: identifier,
                                   title: title,
                                   timestamp: timestamp,
                                   bodyText: mood,
                                   mood: bodyText)
    }
    
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: String = UUID().uuidString, mood: Mood = .neutral, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        guard let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else { return nil }
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier.uuidString,
                  mood: mood,
                  context: context)
    }
}
