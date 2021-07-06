//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😟
    case 😐
    case 😊
    
    static var allMoods: [Mood] {
        return [.😟, .😐, .😊]
    }
}



extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: Mood = .😐, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let title = entryRepresentation.title,
            let bodyText = entryRepresentation.bodyText,
            let mood = Mood(rawValue: entryRepresentation.mood!),
            let timestamp = entryRepresentation.timestamp,
            let identifier = entryRepresentation.identifier else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation {
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, identifier: identifier)
    }

}
