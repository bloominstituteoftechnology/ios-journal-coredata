//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Vincent Hoang on 5/18/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "Happy"
    case neutral = "Neutral"
    case unhappy = "Unhappy"
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
            let title = title,
            let timeStamp = timeStamp,
            let mood = mood,
            let bodyText = bodyText else { return nil }
        
        return EntryRepresentation(identifier: id.uuidString,
                                   title: title,
                                   bodyText: bodyText,
                                   mood: mood,
                                   timeStamp: timeStamp)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timeStamp: Date,
                                        mood: Mood,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp,
                  mood: mood,
                  context: context)
    }
}
