//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Brian Rouse on 5/18/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😃
    case 😫
    case 😐
}

extension Entry {
    @discardableResult convenience init(identifier: String, title: String, bodyText: String, timestamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood) else {
                return nil
        }

        self.init(identifier: entryRepresentation.identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
    }

    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
        let mood = mood,
        let bodyText = bodyText,
        let timestamp = timestamp else { return nil }

        let id = identifier ?? ""

        return EntryRepresentation(identifier: id,
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   mood: mood)
    }
}
