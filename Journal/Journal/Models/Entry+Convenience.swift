//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dahna on 4/20/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case a = "☹️"
    case b = "😐"
    case c = "😊"
}

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        mood: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    
    @discardableResult convenience init?(entryRepresenation: EntryRepresentation, context: NSManagedObjectContext) {
        
        guard let title = entryRepresenation.title,
            let bodyText = entryRepresenation.bodyText,
            let timeStamp = entryRepresenation.timestamp,
            let identifier = entryRepresenation.identifier,
            let mood = entryRepresenation.mood else { return nil }
        
        self.init(identifier: UUID(uuidString: identifier)!, title: title, bodyText: bodyText, timestamp: timeStamp, mood: mood)
    }
    
    var entryRepresentation: EntryRepresentation? {
        
        return EntryRepresentation(identifier: identifier?.uuidString,
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   mood: mood)
    }
}


