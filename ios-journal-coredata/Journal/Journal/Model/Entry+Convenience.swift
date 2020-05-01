//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lydia Zhang on 3/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData
enum Mood: String, Codable {
    case happy = "🙂"
    case neutral = "😐"
    case sad = "🙁"
    
    static var allMoods: [Mood] {
        return [.happy, .neutral, .sad]
    }
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
        let bodyText = bodyText,
        let mood = mood
            else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp ?? Date(), identifier: identifier ?? UUID(), mood: Mood(rawValue: mood) ?? Mood(rawValue: Mood.happy.rawValue)!)
    }
    @discardableResult convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     mood: Mood,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = entryRepresentation.title
        self.bodyText = entryRepresentation.bodyText
        self.timestamp = entryRepresentation.timestamp
        self.identifier = entryRepresentation.identifier
        
    }
}

