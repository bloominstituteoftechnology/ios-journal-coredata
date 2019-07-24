//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😃
    case 😐
    case 😞
    
    static var allMoods = Mood.allCases
}

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String?, mood: String, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up NSManagedObject part of the class
        self.init(context: context)
        
        // Set up the unique parts of the Task class
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        guard let identifierString = entryRepresentation.identifier, let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.title = entryRepresentation.title
        self.bodyText = entryRepresentation.bodyText
        self.mood = entryRepresentation.mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    var entryRepresentation: EntryRepresentation {
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timestamp: timestamp, identifier: identifier?.uuidString)
    }
}
