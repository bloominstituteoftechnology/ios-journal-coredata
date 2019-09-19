//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import Foundation
import CoreData

enum EmojiSelection: String, CaseIterable {
    case 😎
    case 🙏🏼
    case 💪🏽
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let bodyText = bodyText,
        let identifier = identifier?.uuidString,
        let mood = mood,
        let timestamp = timestamp,
        let title = title else { return nil }
        
        print(identifier)
        
        return EntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood, timestamp: timestamp, title: title)
    }
    
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: UUID = UUID(), mood: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier,
                  mood: entryRepresentation.mood,
                  context: context)
        
    }
}
