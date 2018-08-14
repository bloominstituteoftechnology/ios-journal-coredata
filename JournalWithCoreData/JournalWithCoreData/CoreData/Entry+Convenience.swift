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
    case happy
    case neutral
    case sad
    
    static var allMoods: [EntryMood]
    {
        return [.happy, .neutral, .sad]
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
}
