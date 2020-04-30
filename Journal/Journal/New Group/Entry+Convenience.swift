//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Juan M Mariscal on 4/22/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy
    case sad
    case neutral
}

extension Entry {
    
    @discardableResult convenience init( identifier: UUID = UUID(),
                                         title: String,
                                         bodyText: String? = nil,
                                         timestamp: Date = Date(),
                                         mood: Mood,
                                         context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentaion: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentaion.mood.rawValue),
            let identifier = UUID(uuidString: entryRepresentaion.identifier) else {
                return nil
        }
        
        self.init(identifier: identifier,
                  title: entryRepresentaion.title,
                  bodyText: entryRepresentaion.bodyText,
                  timestamp: entryRepresentaion.timeStamp,
                  mood: mood,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood,
            let timestamp = timestamp else { return nil }
        
        let id = identifier ?? UUID()
        
        return EntryRepresentation(identifier: id.uuidString,
                                   title: title,
                                   bodyText: bodyText,
                                   timeStamp: timestamp,
                                   mood: mood)
    }
    
}
