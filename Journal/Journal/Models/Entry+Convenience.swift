//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 🙂
    case 😐
    case 🙁
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let identifier = identifier, let bodyText = bodyText, let timestamp = timestamp, let mood = mood else {return nil}

        return EntryRepresentation(bodyText: bodyText, identifier: identifier.uuidString, mood: mood, timestamp: timestamp, title: title)
    }
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date, mood: String = "😐", identifier: UUID = UUID(), context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifierString = entryRepresentation.identifier
        guard let identifier = UUID(uuidString: identifierString) else { return nil }
        //guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: Date(),
                  mood: entryRepresentation.mood,
                  identifier: identifier,
                  context: context)
    }

}
