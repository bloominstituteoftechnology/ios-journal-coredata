//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Harmony Radley on 4/20/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String, CaseIterable {
    case 🙁
    case 😐
    case 😃
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
        let title = title,
        let timestamp = timestamp,
        let mood = mood else { return nil }
        
       return EntryRepresentation(title: title,
                                  bodyText: bodyText,
                                  timestamp: timestamp,
                                  identifier: id,
                                  mood: mood)
    }
    
    
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date,
                                        identifier: String = String(),
                                        mood: MoodPriority = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
