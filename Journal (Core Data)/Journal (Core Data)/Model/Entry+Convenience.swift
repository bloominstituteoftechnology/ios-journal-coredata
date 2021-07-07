//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let mood = mood else { return nil }
        
        return EntryRepresentation(title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   identifier: identifier,
                                   mood: mood)
    }
    
    @discardableResult
    convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     mood: String = "😐",
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult
    convenience init?(entryRepresentation: EntryRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let title = entryRepresentation.title,
            let bodyText = entryRepresentation.bodyText,
//            let timestampString = entryRepresentation.timestamp,
            let timestamp = entryRepresentation.timestamp,
            let identifierString = entryRepresentation.identifier else { return nil }
//            let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.init(title: title,
                  bodyText: bodyText,
                  timestamp: timestamp,
                  identifier: identifierString,
                  mood: entryRepresentation.mood,
                  context: context)
    }
}

extension Entry {
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
