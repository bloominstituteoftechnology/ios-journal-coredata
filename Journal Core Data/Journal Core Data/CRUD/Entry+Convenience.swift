//
//  Entry+Convenience.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😁 , 🧐 , 😥
}

extension Entry {
    @discardableResult convenience init (title: String,
                      bodyText: String,
                      mood: Mood = .🧐 ,
                      identifier: String,
                      timeStamp: Date = Date(),
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.identifier = identifier
        self.timeStamp = timeStamp
    }
    // new

    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  mood: mood,
                  identifier: entryRepresentation.identifier,
                  timeStamp: entryRepresentation.timeStamp)
        
    }
    
    // did not change Identifier to UUID
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood, let bodyText = bodyText, let timeStamp = timeStamp, let identifier = identifier else {
                return nil
        }
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp, identifier: identifier)
    }
    
}
