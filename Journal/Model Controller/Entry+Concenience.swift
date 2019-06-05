//
//  Entry+Concenience.swift
//  Journal
//
//  Created by Hayden Hastings on 6/3/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😔
    case 😐
    case 🙂
    
    static var allMoods: [Mood] {
        return [.😔, .😐, .🙂]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String? = UUID().uuidString, mood: String = "😐", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: entryRepresentation.mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let moodString = mood,
            let mood = Mood(rawValue: moodString) else { return nil }
        
        if identifier == nil {
            identifier = UUID().uuidString
        }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier!, mood: mood.rawValue)
    }
}
