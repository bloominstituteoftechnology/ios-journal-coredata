//
//  Entry+Convenience.swift
//  Journal
//
//  Created by morse on 11/10/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😞, 😐, 😁
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title,
            let mood = mood,
            let identifier = identifier,
            let timestamp = timestamp else { return nil }
        
        return EntryRepresentation(title: title,
                                   mood: mood,
                                   bodyText: bodyText,
                                   identifier: identifier,
                                   timestamp: timestamp)
    }
    
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        mood: String,
                                        timestamp: Date = Date(),
                                        identifier: String = UUID().uuidString,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let bodyText = entryRepresentation.bodyText else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: bodyText,
                  mood: entryRepresentation.mood,
                  timestamp: entryRepresentation.timestamp,
                  identifier: entryRepresentation.identifier)
    }
}
