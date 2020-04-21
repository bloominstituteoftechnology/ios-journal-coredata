//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chris Dobek on 4/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case sad = "😢"
    case neutral = "😐"
    case happy = "☺️"
}

extension Entry {
    
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: EntryMood = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
}
