//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Moin Uddin on 9/17/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

enum EntryEmoji: String {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"

    
    static var allEmojies: [EntryEmoji] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: entryRepresentation.mood, context: context)
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        let date = dateFormatter.string(from: (self.timestamp)!)
        return date
    }
}
