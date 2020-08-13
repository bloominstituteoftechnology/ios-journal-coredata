//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dojo on 8/5/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😀"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let mood = mood,
            let timestamp = timestamp else { return nil }
        return EntryRepresentation(identifier: identifier?.uuidString ?? "", title: title, bodyText: bodyText, mood: mood, timestamp: timestamp)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        bodyText: String?,
                                        timestamp: Date,
                                        mood: Mood,
                                        title: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        self.title = title
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        
        self.init(identifier: identifier,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  title: entryRepresentation.title,
                  context: context)
    }
}
