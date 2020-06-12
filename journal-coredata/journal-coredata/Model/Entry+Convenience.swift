//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/2/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String, CaseIterable {
    case 😃
    case 🙁
    case 😐
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood else { return nil }

        return EntryRepresentation(identifier: identifier?.uuidString ?? "",
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp ?? Date(),
                                   mood: mood)
    }

    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String?,
                                        timestamp: Date = Date(),
                                        mood: MoodPriority = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
    }

    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = MoodPriority(rawValue: entryRepresentation.mood),
            let identifier = UUID(uuidString: entryRepresentation.identifier) else {
                return nil }

        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
    }
}
