//
//  Entry+Convenience.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/5/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case neutral = "😐"
    case happy = "😃"
    case sad = "🥺"
}

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        timestamp: Date = Date(),
                                        bodyText: String,
                                        mood: EntryMood = .neutral,
                                        context: NSManagedObjectContext  = CoreDataStack.shared.mainContext) {

                                        
                                        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
                                        
    
}
