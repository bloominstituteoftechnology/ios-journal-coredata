//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Stephanie Ballard on 5/18/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "☀️"
    case neutral = "⛅️"
    case sad = "🌧"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
            let title = title,
            let timestamp = timestamp,
            let mood = mood,
            let bodyText = bodyText else { return nil }
        
        return EntryRepresentation(bodyText: bodyText, identifier: id.uuidString, mood: mood, timestamp: timestamp, title: title)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        mood: String = Mood.neutral.rawValue,
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(identifier: identifier, title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, mood: mood.rawValue, timestamp: entryRepresentation.timestamp, context: context)
    }
}
