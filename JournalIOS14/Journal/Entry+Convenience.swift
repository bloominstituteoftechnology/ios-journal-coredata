//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Ufuk Türközü on 24.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 🤢
    case 😐
    case 🤠
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let bodyText = bodyText, let mood = mood, let timestamp = timestamp, let id = id else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp, id: id)
    }
    
    @discardableResult convenience init(title: String,
                                        timestamp: Date,
                                        bodyText: String,
                                        mood: EntryMood = .🤠,
                                        id: String = UUID().uuidString,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.id = id
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  timestamp: entryRepresentation.timestamp,
                  bodyText: entryRepresentation.bodyText,
                  mood: mood,
                  id: entryRepresentation.id,
                  context: context)
    }
}
