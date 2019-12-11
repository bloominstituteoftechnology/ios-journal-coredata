//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/5/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(mood: String = "😭",
                     title: String,
                     timestamp: Date,
                     bodyText: String? = nil,
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.init(mood: entryRepresentation.mood,
                  title: entryRepresentation.title,
                  timestamp: entryRepresentation.timestamp,
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
