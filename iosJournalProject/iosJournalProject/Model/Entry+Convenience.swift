//
//  Entry+Convenience.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/5/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case neutral = "🤩"
    case happy = "🤬"
    case mad = "🙃"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let identifier = identifier,
              let title = title,
              let mood = mood,
              let bodyText = bodyText,
              let timestamp = timestamp
              else { return nil }
        
        return EntryRepresentation(identifier: identifier.uuidString ,
                                   title: title,
                                   timestamp: timestamp,
                                   bodyText: bodyText,
                                   mood: mood)
    }
    
    // identifier?.uuidString ?? ""
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        timestamp: Date,
                                        bodyText: String,
                                        mood: EntryMood = .neutral,
                                        context: NSManagedObjectContext  = CoreDataStack.shared.mainContext) {

                                        
                                        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
    
    // Turn task rep into a Task object
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = EntryMood(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  timestamp: entryRepresentation.timestamp,
                  bodyText: entryRepresentation.bodyText,
                  mood: mood)
        
        
    }
    
    
    
    
    
    
    
                                        
    
}
