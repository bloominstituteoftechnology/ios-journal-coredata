//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 4/28/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case happy = "Happy"
    case sad = "Sad"
    case neutral = "Neutral"
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood = .neutral, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
            self.init(context: context)
            self.title = title
            self.bodyText = bodyText
            self.mood = mood.rawValue
            self.timeStamp = timeStamp
            self.identifier = identifier
        }
    }
