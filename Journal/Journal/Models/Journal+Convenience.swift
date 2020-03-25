//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy
    case neutral
    case sad
}
extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     bodyText: String?,
                     timestamp: Date = Date(),
                     mood: String = Mood.neutral.rawValue,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = Date()
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString),
            let mood = Mood(rawValue: entryRepresentation.mood ?? Mood.neutral.rawValue) else { return nil }
        
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood.rawValue,
                  context: context)
    }
}


