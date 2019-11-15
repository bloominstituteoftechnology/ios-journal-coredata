//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import CoreData

extension Entry {
    // MARK: - Convenience Initializer
    
    convenience init(
        title: String,
        bodyText: String,
        timestamp: Date = Date(),
        mood: Mood?,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood?.rawValue ?? Mood.neutral.rawValue
        self.timestamp = timestamp
        self.identifier = UUID().uuidString
    }
    
    // MARK: - Mood Enum
    
    enum Mood: String, CaseIterable {
        case sad = "😢"
        case neutral = "😐"
        case happy = "😃"
    }
    
    // MARK: - Old ID handler
    
    /// Old IDs contained `.` which couldn't be made into a URL.
    /// This function replaces old IDs with a more compatible one.
    func handleBadID() {
        if let id = identifier, !id.contains(".") {
            // if ID is good, no action needs to be taken
            return
        } else {
            // replace bad/absent ID with good UUID string
            identifier = UUID().uuidString
        }
    }
}
