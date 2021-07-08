//
//  Entry+Convenience.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String
{
    case sad
    case neutral
    case happy
    
    static var allMoods: [EntryMood]
    {
        return [.sad, .neutral, .happy]
    }
}

extension Entry
{
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood = .neutral, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: managedObjectContext)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    convenience init?(entryRespresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(title: entryRespresentation.title,
                  bodyText: entryRespresentation.bodyText,
                  timestamp: entryRespresentation.timestamp,
                  identifier: entryRespresentation.identifier,
                  mood: EntryMood(rawValue: entryRespresentation.mood)!,
                  managedObjectContext: context)
    }
    
    var entryRepresentation: EntryRepresentation?
    {
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let identifier = identifier,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(title: title, bodyText:bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
}
