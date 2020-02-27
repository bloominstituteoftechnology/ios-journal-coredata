//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by scott harris on 2/24/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "😀"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let bodyText = bodyText, let mood = mood, let timestamp = timestamp, let identifier = identifier else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp, identifier: identifier)
    }
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), mood: String, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = entryRepresentation.title
        self.bodyText = entryRepresentation.bodyText
        self.timestamp = entryRepresentation.timestamp
        self.identifier = entryRepresentation.identifier
        self.mood = entryRepresentation.mood
    }
}
