//
//  Entry+Convenience.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 🙁
    case 😐
    case 🙂
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
            let title = title,
            let timestamp = timestamp,
            let bodyText = bodyText,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(identifier: id, title: title, timestamp: timestamp, bodyText: bodyText, mood: mood)
        
    }
    
//    @discardableResult convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//
//        self.init(context: context)
//
//    }
//
    @discardableResult convenience init(identifier: String = String(),
                                        title: String,
                                        timestamp: Date,
                                        bodyText: String,
                                        mood: EntryMood = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
}
