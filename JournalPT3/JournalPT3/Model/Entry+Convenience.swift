//
//  Entry+Convenience.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case low = "🙁"
    case normal = "😏"
    case great = "😁"
    
//    static var allMoods: [EntryMood] {
//        return [.low, .normal, .great]
//    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let mood = mood else { return nil }
        
        return EntryRepresentation(title: title,
                                   timestamp: timestamp ?? Date(),
                                   mood: mood,
                                   identifier: identifier ?? UUID().uuidString,
                                   bodyText: bodyText)
    }
    
    convenience init(title: String,
                     mood: EntryMood = .normal,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: String? = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = EntryMood(rawValue: entryRepresentation.mood),
            let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else {
                return nil
        }
        
        self.init(title: entryRepresentation.title,
                  mood: mood,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier.uuidString,
                  context: context)
    }
}
