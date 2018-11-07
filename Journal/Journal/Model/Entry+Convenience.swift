//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sean Hendrix on 11/5/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String, CaseIterable {
    case happy = "😃",
    sad = "😢",
    neutral = "😐"
    static var allMoods: [Moods] {
        return[.happy, .sad, .neutral]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String?, mood: Moods = .neutral, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Moods(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, mood: mood, timestamp: entryRepresentation.timestamp, identifier: identifier, context: context)
        
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timestamp = timestamp,
            let mood = mood,
            let identifier = identifier else { return nil }
        return EntryRepresentation(title: title,
                                   bodyText: bodyText,
                                   mood: mood,
                                   timestamp: timestamp,
                                   identifier: identifier.uuidString)
    }
    
}
