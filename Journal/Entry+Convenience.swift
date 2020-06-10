//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kenneth Jones on 6/3/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy, neutral, sad
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood else { return nil }
        
        return EntryRepresentation(identifier: identifier?.uuidString ?? "", title: title, bodyText: bodyText, mood: mood, timestamp: timestamp ?? Date())
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        mood: Mood = .happy,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else {
                return nil }
        
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
    }
}
