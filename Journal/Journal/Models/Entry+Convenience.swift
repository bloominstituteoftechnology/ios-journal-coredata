//
//  Entry+Convenience.swift
//  Journal
//
//  Created by John Kouris on 9/30/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let identifier = identifier?.uuidString,
            let timestamp = timestamp,
            let mood = mood else { return nil }
            
        return EntryRepresentation(title: title, bodyText: bodyText, identifier: identifier, mood: mood, timestamp: timestamp)
    }
    
    convenience init(title: String, bodyText: String?, identifier: UUID = UUID(), timestamp: Date = Date(), mood: Mood, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, identifier: identifier, timestamp: entryRepresentation.timestamp, mood: mood, context: context)
    }
    
}
