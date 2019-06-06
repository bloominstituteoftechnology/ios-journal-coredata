//
//  Entry+Convenience.swift
//  Journal - Day 3
//
//  Created by Sameera Roussi on 6/3/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "😥"
    case neutral = "😐"
    case happy = "🤗"
}

extension Entry {
    
    convenience init(title: String, bodyText: String, mood: String, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        (self.title, self.bodyText, self.mood, self.timestamp, self.identifier) = (title, bodyText, mood, timestamp, identifier)
    }
}

