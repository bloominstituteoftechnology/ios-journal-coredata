//
//  Entry+Convenience.swift
//  Journal - CoreData
//
//  Created by Nichole Davidson on 4/20/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 🙁
    case 😐
    case 🙂
}

extension Entry {
    @discardableResult convenience init(identifier: String = String(),
                                        title: String,
                                        timestamp: Date,
                                        mood: EntryMood.RawValue,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.mood = mood
    }
}
