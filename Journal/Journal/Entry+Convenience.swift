//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Thomas Sabino-Benowitz on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😾, 😺, 😸
}

extension Entry {
    @discardableResult convenience init(bodyText: String? = nil,
                     identifier: UUID = UUID(),
                     timestamp: Date? = Date(),
                     title: String,
                     mood: Mood = .😺,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let identifierString = entryRepresentation.identifier,
        let identifier = UUID(uuidString: identifierString) else { return nil}
        
        self.init(bodyText: entryRepresentation.bodyText,
                  identifier: identifier,
                  timestamp: entryRepresentation.timestamp,
                  title: entryRepresentation.title,
                  mood: mood,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood else { return nil }
        
        return EntryRepresentation(bodyText: bodyText, identifier: identifier?.uuidString ?? " ", mood: mood, timestamp: timestamp!, title: title)
        
    }
}
