//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😄"
    case sad = "😔"
    case neutral = "😐"
}

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        mood: Mood,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood.init(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else {
                return nil
        }
        
        self.init(identifier: identifier,
                   title: entryRepresentation.title,
                   bodyText: entryRepresentation.bodyText ?? "",
                   timestamp: entryRepresentation.timestamp,
                   mood: mood,
                   context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title,
            let mood = mood,
            let timestamp = timestamp else { return nil }
        
        let id = identifier ?? UUID()
        
        return EntryRepresentation(bodyText: bodyText,
                                   identifier: id.uuidString,
                                   mood: mood,
                                   timestamp: timestamp,
                                   title: title)
        
    }
    
}
