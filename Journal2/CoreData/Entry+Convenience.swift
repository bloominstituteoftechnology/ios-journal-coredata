//
//  Entry+Convenience.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/20/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String
{
    case sad
    case neutral
    case happy
    case angry
    
    static var allMoods: [Mood]
    {
        return [.sad, .neutral, .happy, .angry]
    }
}

extension Entry
{
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identitifier: String = UUID().uuidString, mood: Mood = .angry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identitifier
        self.mood = mood.rawValue
    }
}
