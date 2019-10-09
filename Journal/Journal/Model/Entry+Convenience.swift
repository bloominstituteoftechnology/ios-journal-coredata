//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/1/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case horrible = "😡"
    case interesting = "🤨"
    case awesome = "😁"
}

extension Entry {
    convenience init(
        title: String, bodyText: String? = nil, timeStamp: Date = Date(), identifier: String, mood: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init? (entryRepresentation: EntryRepresentation,
                       context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        guard let identifier = entryRepresentation.identifier else { return nil }
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp, identifier: identifier, mood: entryRepresentation.mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timeStamp = timeStamp,
            let mood = mood else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, identifier: identifier)
    }
    
    
}
