//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😁"
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = self.title,
            let timestamp = self.timestamp,
            let identifier = self.identifier,
            let mood = self.mood else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp, identifier: identifier)
    }
    
    convenience init(title: String, bodyText: String? = nil, mood: EntryMood = .neutral, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = EntryMood(rawValue: entryRepresentation.mood!),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, mood: mood, timestamp: entryRepresentation.timestamp, identifier: identifier.uuidString, context: context)
    }
}
