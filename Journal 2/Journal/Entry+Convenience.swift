//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, Codable, Equatable {
    case 🍕
    case 🍔
    case 🌮
    static var allMoods: [EntryMood] {
        return [.🍕, .🍔, .🌮]
    }
}

extension Entry {

    convenience init(title: String, timestamp: Date = Date(), identifier: UUID = UUID(), bodyText: String? = nil, mood: String = "🍕", context: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {

        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.identifier = identifier
        self.bodyText = bodyText
        self.mood = mood
    }

    convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(title: entryRepresentation.title, timestamp: entryRepresentation.timestamp ?? Date(), identifier: entryRepresentation.identifier, bodyText: entryRepresentation.bodyText, mood: entryRepresentation.mood.rawValue, context: context )

    }


    var entryRepresentation: EntryRepresentation! {
        guard let title = title,
            let moodString = mood,
            let mood = EntryMood(rawValue: moodString) else { return nil}

        if identifier == nil {
            identifier = UUID()
        }
        return EntryRepresentation(identifier: identifier!, title: title, bodyText: bodyText, timestamp: timestamp!, mood: mood)


    }
    


}
