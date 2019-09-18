//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/16/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let entryBodyText = bodyText,
            let entryIdentifier = identifier,
            let entryMood = mood,
            let entryTimestamp = timestamp,
            let entryTitle = title else { return nil }
        
        return EntryRepresentation(bodyText: entryBodyText, identifier: entryIdentifier, mood: entryMood, timestamp: entryTimestamp, title: entryTitle)
    }
    
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: UUID, mood: String, context: NSManagedObjectContext) {
    
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRep: EntryRepresentation, context: NSManagedObjectContext) {
        
        self.init(title: entryRep.title,
                  bodyText: entryRep.bodyText,
                  timestamp: entryRep.timestamp,
                  identifier: entryRep.identifier,
                  mood: entryRep.mood,
                  context: context)
    }
}
