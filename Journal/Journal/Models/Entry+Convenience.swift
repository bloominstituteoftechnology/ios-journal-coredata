//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dahna on 5/18/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😊"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let id = identifier,
        let title = title,
        let bodyText = bodyText,
        let timestamp = timestamp,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(identifier: id,
                                    title: title,
                                    bodyText: bodyText,
                                    timestamp: timestamp,
                                    mood: mood)
    }
    
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                                         title: String,
                                         bodyText: String,
                                         timestamp: Date = Date(),
                                         mood: Mood = .neutral,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood) else {
                return nil
        }
        
        self.init(identifier: identifier.uuidString,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
    }
}
