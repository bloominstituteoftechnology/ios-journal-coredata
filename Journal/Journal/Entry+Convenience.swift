//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String,
                                        timestamp: Date,
                                        mood: String = "😐",
                                        bodyText: String? = nil,
                                        identifier: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.mood = mood
        self.bodyText = bodyText
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  timestamp: entryRepresentation.timestamp,
                  mood: entryRepresentation.mood,
                  bodyText: entryRepresentation.bodyText,
                  identifier: identifier,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timestamp = timestamp,
            let mood = mood else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, identifier: identifier?.uuidString ?? "")
    }
}
