//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Samantha Gatt on 8/13/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
    
    static var moods = [EntryMood.sad, EntryMood.neutral, EntryMood.happy]
}

extension Entry {
    convenience init(title: String, body: String?, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
