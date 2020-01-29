//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let identifier = identifier
        else {return nil}
        return EntryRepresentation(bodyText: bodyText, identifier: identifier.uuidString, mood: mood, timestamp: timestamp, title: title)
    }
    
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: UUID, mood: String = "😑", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: UUID(uuidString: entryRepresentation.identifier)!, mood: entryRepresentation.mood ?? "😑") //no reason UUID should fail. it comes from a UUID to begin with
    }
    
}
