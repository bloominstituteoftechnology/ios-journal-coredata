//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Craig Swanson on 12/4/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case doh = "🤦‍♂️"
    case meh = "🤷‍♂️"
    case yea = "🕺"
    
    static var allMoods: [Mood] {
        return [.doh, .meh, .yea]
    }
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title else { return nil }
        return EntryRepresentation(bodyText: bodyText, identifier: identifier ?? UUID().uuidString, mood: mood, timestamp: timestamp ?? Date(), title: title)
    }
    convenience init(title: String, mood: Mood = .meh, bodyText: String? = nil, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let unwrappedMood = entryRepresentation.mood,
            let mood = Mood(rawValue: unwrappedMood) else { return nil }
        
        self.init(title: entryRepresentation.title, mood: mood, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, context: context)
    }
}
