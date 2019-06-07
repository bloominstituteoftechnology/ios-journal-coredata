//
//  Entry+Convenience.swift
//  Journal - Day 3
//
//  Created by Sameera Roussi on 6/3/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable, Codable {
    case sad = "😥"
    case neutral = "😐"
    case happy = "🤗"
}

extension Entry {
    
    convenience init(title: String, bodyText: String?, mood: String, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        (self.title, self.bodyText, self.mood, self.timestamp, self.identifier) = (title, bodyText, mood, timestamp, identifier)
    }
    
    // Turn an entry object -> representation
    convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
    self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, mood: entryRepresentation.mood, timestamp: entryRepresentation.timestamp!, identifier: entryRepresentation.identifier, context: context)
    }
    
    // Turn a representation into an entry object.  We will use a computed property
    var entryRepresentation: EntryRepresentation? {
        guard let title = title else { return nil }
        
        let entryIdentifier = identifier ?? UUID()
        identifier = entryIdentifier
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood ?? "😐", timestamp: timestamp, identifier: entryIdentifier)
    }
    
    
}

