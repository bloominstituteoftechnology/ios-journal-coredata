//
//  Entry + Convenience.swift
//  CoreDataJournal
//
//  Created by Joe Veverka on 5/18/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//
enum Mood: String, CaseIterable {
    case happy = "happy"
    case sad = "sad"
    case neutral = "neutral"
}

import Foundation
import CoreData

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
            let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(bodyText: bodyText,identifier:  id.uuidString, mood: mood, timestamp: timestamp, title: title)
        
    }
    
    
    
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timestamp: Date? = Date(),
                                        identifier: UUID = UUID(),
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext){
        self.init(context : context)
        self.title = title
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = Mood(rawValue: entryRepresentation.mood)
             else { return nil }
        let bodyText = entryRepresentation.bodyText
        
        
        self.init(title: entryRepresentation.title, bodyText: bodyText, timestamp: entryRepresentation.timestamp, identifier: identifier, mood: mood, context: context)
        
        
    }
}
