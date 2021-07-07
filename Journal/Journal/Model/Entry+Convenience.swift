//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case sad = "😨"
    case neutral = "😐"
    case happy = "🥳"
    
    static var allMoods: [EntryMood] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    
    convenience init (title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        (self.title, self.bodyText, self.timestamp, self.identifier, self.mood) = (title, bodyText, timestamp, identifier, mood.rawValue)
    }
    
    convenience init?(entryRepresentation: EntryRepresentation) {
        
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: mood)
    }
}
