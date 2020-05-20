//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Enzo Jimenez-Soto on 5/18/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case sad = "🙁"
    case okay = "😐"
    case happy = "🙂"
}

extension Entry {
    convenience init(mood: EntryMood = .okay, title: String, bodyText: String? = nil, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.init(mood: EntryMood(rawValue: entryRepresentation.mood) ?? .okay, title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, identifier: identifier, context: context)
        
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood,
            let bodyText = bodyText,
            let timestamp = timestamp
        else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp, identifier: identifier?.uuidString ?? "")
    }
}
