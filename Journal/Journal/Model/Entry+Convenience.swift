//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable, Codable {
    case happy = "😃"
    case neutral = "😐"
    case sad = "🙁"
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, identifier: String = UUID().uuidString, timeStamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let title = entryRepresentation.title,
            let bodyText = entryRepresentation.bodyText,
            let identifier = entryRepresentation.identifier,
            let timeStamp = entryRepresentation.timeStamp,
            let moodString = entryRepresentation.mood,
            let mood = Mood(rawValue: moodString)  else { return nil }
        
        self.init(title: title, bodyText: bodyText, identifier: identifier, timeStamp: timeStamp, mood: mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation {
        return EntryRepresentation(title: title, timeStamp: timeStamp, mood: mood, identifier: identifier, bodyText: bodyText)
    }
    
}

