//
//  Entry+Convenience.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case sad = "😟"
    case neutral = "😐"
    case happy = "😃"
    
    static var allMoods: [EntryMood] {
        return [.sad, .neutral, .happy]
    }
}


extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identiifier: String = UUID().uuidString, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identiifier
        self.mood = mood.rawValue
    }
}
