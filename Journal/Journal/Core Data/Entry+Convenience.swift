//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String {
    case 😔
    case 😐
    case 🙂
    
    static var allPriorities: [MoodPriority] {
        return [.😔, .😐, .🙂]
    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let mood = mood else { return nil }
        
        return EntryRepresentation(bodyText: bodyText ?? "",
                                   identifier: identifier,
                                   mood: mood,
                                   timestamp: timestamp,
                                   title: title ?? "")
    }
    
    @discardableResult convenience init(mood: MoodPriority = .😐,
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        identifier: String = "",
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let moodPriority = MoodPriority(rawValue: entryRepresentation.mood),
              let date = entryRepresentation.timestamp  else {
            return nil
        }
        
        self.init(mood: moodPriority,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText ?? "",
                  timestamp: date,
                  identifier: entryRepresentation.identifier ?? "",
                  context: context)
    }
}




