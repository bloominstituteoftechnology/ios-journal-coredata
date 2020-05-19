//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dahna on 5/18/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😊"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                                          title: String,
                                          bodyText: String,
                                          timestamp: Date = Date(),
                                          mood: String = Mood.neutral.rawValue,
                                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood
    }
    
}
