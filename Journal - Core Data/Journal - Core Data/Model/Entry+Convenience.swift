//
//  Entry+Convenience.swift
//  Journal - Core Data
//
//  Created by Lisa Sampson on 8/20/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case happy = "😊"
    case sad = "😢"
    case neutral = "😐"
    
    static var allMoods: [EntryMood] {
        return [.happy, .sad, .neutral]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    convenience init?(entryRepresentation: EntryRepresentation) {
        
        guard let title = entryRepresentation.title,
            let bodyText = entryRepresentation.bodyText,
            let timestamp = entryRepresentation.timestamp,
            let identifier = entryRepresentation.identifier,
            let moodString = entryRepresentation.mood,
            let mood = EntryMood(rawValue: moodString) else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
}
