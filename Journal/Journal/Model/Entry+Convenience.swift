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
    
    var entryRepresentation: EntryRepresentation? {
        guard let bodyText = bodyText,
            let identifier = identifier,
            let mood = mood,
            let timestamp = timestamp,
            let title = title else {
            return nil
        }
        
        return EntryRepresentation(bodyText: bodyText,
                                   identifier: identifier,
                                   mood: mood,
                                   timestamp: timestamp,
                                   title: title)
    }
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood, identifier: String = "", context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else {
            return nil
        }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  identifier: entryRepresentation.identifier,
                  context: context)
    }
}
