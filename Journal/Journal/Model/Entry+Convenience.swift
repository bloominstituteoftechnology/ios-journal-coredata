//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Shawn James on 4/20/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case a = "☹️"
    case b = "😐"
    case c = "🙂"
}

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        timestamp: Date = Date(),
                                        bodyText: String? = nil,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                                        mood: String = "😐") {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood
    }
}
