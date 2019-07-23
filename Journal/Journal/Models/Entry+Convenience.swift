//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case happy = "😃"
    case neutral = "😐"
    case sad = "😞"
    
    static var allMoods: [Mood] {
        return [.happy, .neutral, .sad]
    }
}

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String?, mood: String, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up NSManagedObject part of the class
        self.init(context: context)
        
        // Set up the unique parts of the Task class
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
}
