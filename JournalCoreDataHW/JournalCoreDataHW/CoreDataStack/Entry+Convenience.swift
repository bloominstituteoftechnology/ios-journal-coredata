//
//  Entry+Convenience.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case happy = "😃"
    case chillin = "😐"
    case sad = "😟"
    
    static var allMoods: [EntryMood] {
        return [.happy, .chillin, .sad]
    }
}

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        //initialize the object in the context
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    
    }
}
