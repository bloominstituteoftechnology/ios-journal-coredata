//
//  Entry+Convenience.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 🤩
    case 🧐
    case 😖
    
    static var allMoods: [Mood] {
        return[🤩, 🧐, 😖]
    }
}


extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date? = Date(), identifier: UUID = UUID(), mood: Mood = .🧐, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
    convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: Mood(rawValue: entryRepresentation.mood)!, context: context)
        
    }
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let moodString = mood,
            let mood = Mood(rawValue: moodString),
            let bodyText = bodyText,
            let timestamp = timestamp else { return nil }
        
        // if the old data does not have an identifier, let's create one
        if identifier == nil {
            identifier =  UUID()
        }
        return EntryRepresentation(bodyText: bodyText, identifier: identifier!, mood: mood.rawValue, timestamp: timestamp, title: title)
    }
}

