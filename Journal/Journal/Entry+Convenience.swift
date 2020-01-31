//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Ufuk Türközü on 27.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 🤢
    case 😐
    case 🤪
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let timestamp = timestamp, let identifier = identifier, let mood = mood, let bodyText = bodyText else { return nil }
        
        return EntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood, timestamp: timestamp, title: title)
    }
    
    convenience init(title: String,
                     timestamp: Date,
                     bodyText: String,
                     identifier: String = UUID().uuidString,
                     mood: EntryMood,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  timestamp: entryRepresentation.timestamp,
                  bodyText: entryRepresentation.bodyText,
                  identifier: entryRepresentation.identifier,
                  mood: mood,
                  context: context)
    
    }
}
