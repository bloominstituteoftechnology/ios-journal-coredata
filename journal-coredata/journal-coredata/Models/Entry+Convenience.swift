//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
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
        guard let identifier = identifier,
            let title = title else { return nil }
        return EntryRepresentation(identifier: identifier, title: title, bodyText: bodyText, timestamp: timestamp ?? Date(), mood: mood ?? Mood.neutral.rawValue)
    }
    
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                                        title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText ?? ""
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(representation: EntryRepresentation, context: NSManagedObjectContext) {
        self.init(identifier: representation.identifier,
                  title: representation.title,
                  bodyText: representation.bodyText ?? nil,
                  timestamp: representation.timestamp,
                  mood: Mood(rawValue: representation.mood) ?? .neutral,
                  context: CoreDataStack.shared.mainContext)
    }
}
