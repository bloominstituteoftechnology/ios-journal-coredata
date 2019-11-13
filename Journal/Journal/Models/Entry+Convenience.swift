//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import CoreData

extension Entry {
    // MARK: - Convenience Initializers
    
    convenience init(
        title: String,
        bodyText: String,
        timestamp: Date = Date(),
        mood: Mood?,
        identifier: String = UUID().uuidString,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood?.rawValue ?? Mood.neutral.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    // MARK: - Mood Enum
    
    enum Mood: String, CaseIterable {
        case sad = "😢"
        case neutral = "😐"
        case happy = "😃"
    }
}
