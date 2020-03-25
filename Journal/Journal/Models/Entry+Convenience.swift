//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Mark Gerrior on 3/23/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    /// These need to match the database. i.e. Default value in database model.
    /// Same order as segmented control
    case happy = "😄"
    case neutral = "😐"
    case sad = "☹️"

    static func index(_ mood: String) -> Int {
        for (index, aMood) in Mood.allCases.enumerated() {
            if mood == aMood.rawValue {
                return index
            }
        }
        fatalError("Unknow mood discovered: \(mood)")
    }
}

/// Because we choose class define in Tasks.xcdaatamodeld, Task gets generated behind the scenes
extension Entry {
    
    // TODO: ? Coming in from Firebase. Do not like this much magic.
    // TODO: ? Unclear a lot of the time what type is mood?
    // FIXME: Is this right? And what do I need to unwrap? Or will I get errors to let me know?
    var entryRepresentation: EntryRepresentation? {
        guard let identifier = identifier,
            let title = title,
            let mood = mood else { return nil }
        
        return EntryRepresentation(identifier: identifier,
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   mood: mood)
    }

    @discardableResult convenience init(identifier: String,
                     title: String,
                     bodyText: String? = nil,
                     timestamp: Date? = nil,
                     mood: Mood = .neutral,
                     context: NSManagedObjectContext) {
        /// Magic happens here
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }

    /// Convenience Initializer
    /// Items coming in from Firebase for CoreData
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        /// mood comes in as a string from Firebase. We need to convert to Mood enum
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
}
