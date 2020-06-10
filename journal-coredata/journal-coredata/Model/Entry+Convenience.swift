//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/2/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String, CaseIterable {
    case 😃
    case 🙁
    case 😐
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let identifier = identifier?.uuidString,
            let mood = mood else {
                return nil
        }
        return EntryRepresentation(identifier: identifier,
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   mood: mood)
    }
    
    
    
    
    @discardableResult convenience init(title: String?,
                                        bodyText: String?,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: MoodPriority = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = MoodPriority(rawValue: entryRepresentation.mood) else {
                return nil
        }
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier,
                  mood: mood,
                  context: context)
    }
}
