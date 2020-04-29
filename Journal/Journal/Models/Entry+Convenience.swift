//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Matthew Martindale on 4/21/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable, Codable {
    case sad = "😢"
    case neutral = "😐"
    case happy = "😄"
}

extension Entry {
    @discardableResult convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     mood: Mood,
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let bodyText = entryRepresentation.bodyText,
            let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
    
    
        self.init(title: entryRepresentation.title,
                  bodyText: bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier,
                  mood: mood,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timestamp = timestamp,
            let mood = mood else { return nil }
        
        let id = identifier ?? UUID()
        
        return EntryRepresentation(title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   identifier: id.uuidString,
                                   mood: mood)
    }
    
}
