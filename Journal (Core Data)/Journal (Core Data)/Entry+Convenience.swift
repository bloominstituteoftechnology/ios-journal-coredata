//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Michael on 1/27/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
    
    static var allMoods: [Mood] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard
            let title = title,
            let bodyText = bodyText,
            let mood = mood
            else { return nil }
        return EntryRepresentation(title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp ?? Date(),
                                   identifier: identifier ?? UUID().uuidString,
                                   mood: mood)
    }
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date? = Date(), identifier: String? = UUID().uuidString, mood: Mood = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard
            let mood = Mood(rawValue: entryRepresentation.mood)
            else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: entryRepresentation.identifier,
                  mood: mood,
                  context: context)
    }
}
