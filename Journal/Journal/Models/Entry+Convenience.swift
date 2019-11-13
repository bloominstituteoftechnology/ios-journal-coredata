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
    
    // MARK: - Entry Representation
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = self.title,
            let body = self.bodyText,
            let mood = self.mood,
            let timestamp = self.timestamp,
            let id = self.identifier
            else {
                print("Error generating entry representation for entry; one of the required properties is nil!")
                return nil
        }
        return EntryRepresentation(
            title: title,
            bodyText: body,
            mood: mood,
            timestamp: timestamp,
            identifier: id)
    }
    
    convenience init?(
        representation: EntryRepresentation,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.title = representation.title
        self.bodyText = representation.bodyText
        self.mood = representation.mood
        self.timestamp = representation.timestamp
        self.identifier = representation.identifier
    }
    
    // MARK: - Mood Enum
    
    enum Mood: String, CaseIterable {
        case sad = "😢"
        case neutral = "😐"
        case happy = "😃"
    }
}
