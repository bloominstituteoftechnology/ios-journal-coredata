//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Hunter Oppel on 4/20/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

enum MoodProperties: String, CaseIterable {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
}

extension Entry {
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: MoodProperties = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
