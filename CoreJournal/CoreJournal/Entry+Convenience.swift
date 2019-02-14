//
//  Entry+Convenience.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import CoreData

enum EntryMood: String {
    case happy
    case neutral
    case sad
    
    static var allMoods: [EntryMood] {
        return [.happy, .neutral, .sad]
    }
}

extension Entry {
    
    convenience init(title: String?, bodyText: String?, timestamp: Date?, identifier: UUID = UUID(), mood: EntryMood = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // Setting up the NSManagedObject (the cored data related) part of the Task object
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        // The identifier could be in the wrong format
        // The priority could be something other than the 4 priorities
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
            let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: identifier, mood: mood, context: context)
    }
}
