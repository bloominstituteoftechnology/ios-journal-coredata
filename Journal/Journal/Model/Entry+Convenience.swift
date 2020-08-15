//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Cora Jacobson on 8/5/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😀"
    case sad = "☹️"
    case neutral = "😐"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let mood = mood,
            let timestamp = timestamp else { return nil }
        return EntryRepresentation(identifier: identifier?.uuidString ?? "", title: title, bodyText: bodyText, mood: mood, timestamp: timestamp)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(), title: String, bodyText: String, mood: Mood, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  mood: mood,
                  context: context)
    }
    
}
