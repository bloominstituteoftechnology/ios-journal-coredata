//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Casualty on 10/2/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
}

extension Entry {
    
    convenience init(mood: EntryMood = .neutral,
                     title: String,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: String = "",
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
