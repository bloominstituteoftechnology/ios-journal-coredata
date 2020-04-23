//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Mark Poggi on 4/20/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String, CaseIterable {   
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😀"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let identifier = identifier, let title = title,
            let mood = mood, let timestamp = timestamp else { return nil
                
        }
        
        return EntryRepresentation(identifier: identifier.uuidString,
                                   title: title,
                                   bodyText: bodyText,
                                   mood: mood, timestamp: timestamp)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        mood: MoodPriority = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = MoodPriority(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier)
            else {
                return nil
        }
        
        self.init(identifier: identifier, title: entryRepresentation.title, bodyText: entryRepresentation.bodyText ?? "", mood: MoodPriority(rawValue: entryRepresentation.mood) ?? MoodPriority.neutral, context: context)
    }

}
