//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Scott Bennett on 9/24/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😀"
    
    static var allMoods: [EntryMood] {
        return[.sad, .neutral, .happy]
    }
}

extension Entry {
    convenience init(title: String,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     mood: EntryMood = .neutral,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier.uuidString
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil}
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier,
                  mood: mood,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let mood = mood,
            let identifier = identifier else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp, identifier: identifier)
    }
    
}


