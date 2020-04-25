//
//  Entry+Convenience.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case ecstatic = "😀"
    case dejected = "😫"
    case meh = "😐"
}

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        mood: Mood,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
}
