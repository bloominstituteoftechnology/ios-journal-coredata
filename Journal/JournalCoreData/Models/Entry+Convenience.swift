//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Spencer Curtis on 8/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 👍
    case 🤙
    case 👎
    
    static var allMoods: [Mood] {
        return [.👍, .🤙, .👎]
    }
    
}

extension Entry {
    
    @discardableResult convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     mood: String,
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext()) {
        
        // This is just setting up the NSManagedObject part of the Entry class.
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext()) {
        
        guard let title = entryRepresentation.title,
            let bodyText = entryRepresentation.bodyText,
            let mood = entryRepresentation.mood,
            let timestamp = entryRepresentation.timestamp,
            let identifier = entryRepresentation.identifier else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, identifier: identifier)
        
    }
    
    var entryRepresentation: EntryRepresentation {
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, identifier: identifier)
    }
}
