//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chris Gonzales on 2/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    var entryRepresentation: EntryRepresenation? {
        
        guard let identifier = identifier,
            let title = title,
            let bodyText = bodyText,
            let mood = mood,
            let timestamp = timestamp else { return nil}
        
        return EntryRepresenation(identifier: identifier.uuidString,
                                  title: title,
                                  bodyText: bodyText,
                                  mood: mood,
                                  timestamp: timestamp)
    }
    
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        identifier: UUID,
                                        mood: String = "🤨",
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(representation: EntryRepresenation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: representation.title,
                  bodyText: representation.bodyText,
                  timestamp: representation.timestamp,
                  identifier: UUID(uuidString: representation.identifier)!,
                  mood: representation.mood)
    }
}
