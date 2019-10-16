//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/14/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

enum JournalMood: String, CaseIterable {
    case sad = "☹️"
    case normal = "😐"
    case happy = "🙂"
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let mood = mood, let bodyText = bodyText, let timestamp = timestamp, let identifier = identifier else { return nil }
        return EntryRepresentation(title: title, mood: mood, bodyText: bodyText, timestamp: timestamp, identifier: identifier)
    }
    
    @discardableResult convenience init(title: String, mood: JournalMood, bodyText: String, timestamp: Date? = Date(), identifier: String? = UUID().uuidString, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        guard let mood = JournalMood(rawValue: entryRepresentation.mood) else { return nil}
        
        self.init(title: entryRepresentation.title, mood: mood, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, context: context)
    }
}
