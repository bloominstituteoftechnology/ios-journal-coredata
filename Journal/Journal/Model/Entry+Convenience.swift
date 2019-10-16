//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "😩"
    case eh = "😕"
    case happy = "😄"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title,
            let timestamp = timestamp,
            let bodyText = bodyText,
            let mood = mood,
            let identifier = identifier else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, identifier: identifier)
    }
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date.init(timeIntervalSinceNow: 0), identifier: String = "", mood: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: entryRepresentation.identifier,
                  mood: mood.rawValue,
                  context: context)
    }
}
