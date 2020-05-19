//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Brian Rouse on 5/18/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😃
    case 😫
    case 😐
}

extension Entry {
    @discardableResult convenience init(identifier: String, title: String, bodyText: String, timestamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}
