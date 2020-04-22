//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Shawn James on 4/20/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case a = "☹️"
    case b = "😐"
    case c = "🙂"
}

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, h:mm a"
    return dateFormatter
}()

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
            let title = title,
            let mood = mood,
            let timestamp = timestamp else {
                return nil
        }
        
        return EntryRepresentation(identifier: id.uuidString,
                                   title: title,
                                   bodyText: bodyText,
                                   mood: mood,
                                   timestamp: timestamp)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        timestamp: String = dateFormatter.string(from: Date()),
                                        bodyText: String? = nil,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                                        mood: String = "😐") {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood
    }
}
