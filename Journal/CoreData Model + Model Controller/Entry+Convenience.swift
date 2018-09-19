//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😟
    case 🤓
    case 🤠
    
    static var allMoods: [Mood] {
        return [.😟, .🤓, .🤠]
    }
}

extension Entry {
    
    convenience init(title: String, bodyText: String?, mood: Mood = .🤓, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
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
