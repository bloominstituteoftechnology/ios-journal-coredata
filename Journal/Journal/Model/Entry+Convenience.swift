//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import CoreData

enum EntryMood: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
    
    
    static var allMoods: [EntryMood] {
        return  [.sad, .neutral, .happy]
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
            let identifer = entryRepresentation.identifier,
            let moodString = entryRepresentation.mood,
            let mood = EntryMood(rawValue: moodString) else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifer, mood: mood)
    }
}
