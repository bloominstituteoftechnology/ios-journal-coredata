//
//  Entry+Convenience.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, identifier: String = UUID().uuidString, timestamp: Date = Date(), mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood
    }
    
    // In the "Entry+Convenience.swift" file, add a new convenience initializer. This initializer should be failable
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let title = entryRepresentation.title,
        let bodyText = entryRepresentation.bodyText,
        let identifier = entryRepresentation.identifier,
        let timestamp = entryRepresentation.timestamp,
        let mood = entryRepresentation.mood else { return nil}
        self.init(title: title, bodyText: bodyText, identifier: identifier, timestamp: timestamp, mood: mood, context: context)
    }
}
