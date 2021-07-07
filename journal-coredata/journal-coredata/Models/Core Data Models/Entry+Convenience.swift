//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Alex Shillingford on 8/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String, CaseIterable {
    case happy = "😎"
    case neutral = "😐"
    case sad = "🥺"
}

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: UUID = UUID(), mood: String = "😐", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRep: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let title = entryRep.title,
            let bodyText = entryRep.bodyText,
            let timestamp = entryRep.timestamp,
            let identifier = entryRep.identifier,
            let mood = entryRep.mood else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation {
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
}
