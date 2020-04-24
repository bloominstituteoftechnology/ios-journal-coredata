//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dahna on 4/20/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case a = "☹️"
    case b = "😐"
    case c = "😊"
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
        
        return EntryRepresentation(identifier: id.uuidString,
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   mood: mood)
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood) else {
                return nil
        }
        
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
        
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        mood: Mood = .c,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = Date()
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}


