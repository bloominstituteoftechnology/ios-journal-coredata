//
//  Entry+Convenience.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     mood: EntryMood,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context:context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
    
    convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: entryRepresentation.identifier,
                  mood: entryRepresentation.mood,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let moodString = mood,
        let mood = EntryMood(rawValue: moodString) else {
                return nil
                
        }
        
        if identifier == nil {
            identifier = UUID()
        }
        
        if timestamp == nil {
            timestamp = Date()
        }
        
        return EntryRepresentation(bodyText: bodyText,
                                   identifier: identifier!, mood: mood,
                                   timestamp: timestamp!,
                                   title: title)
    }
}
