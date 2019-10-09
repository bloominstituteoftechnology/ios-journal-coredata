//
//  JournalEntry+Convenience.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: Int, CaseIterable {
    case bad = 0
    case meh = 1
    case good = 2
    
    var stringValue: String {
        switch self {
        case .bad:
            return "😭"
        case .meh:
            return "😐"
        case .good:
            return "😎"
        }
    }
}

extension JournalEntry {
    convenience init(title: String, bodyText: String, mood: EntryMood = .meh, timestamp: Date = Date(), identifier: String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.stringValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(representation: JournalEntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = representation.title
        self.bodyText = representation.bodyText
        self.mood = representation.mood
        self.timestamp = representation.timestamp
        self.identifier = representation.identifier
    }
    
    var representation: JournalEntryRepresentation? {
        guard let title = title else { return nil }
        return JournalEntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood!, timestamp: timestamp ?? Date(), title: title)
    }
}
