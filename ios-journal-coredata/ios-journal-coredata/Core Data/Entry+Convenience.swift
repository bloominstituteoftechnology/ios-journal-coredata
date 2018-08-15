//
//  Entry+Convenience.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData


enum Mood: String {
    case sad = "☹️"
    case meh = "😐"
    case happy = "🙂"

    static var allMoods: [Mood] {
        return [.sad, .meh, .happy]
    }
}

extension Entry {

    convenience init(title: String,
        identifier: String,
        timestamp: Date,
        bodyText: String,
        mood: Mood = .meh,
        managedObjectContext: NSManagedObjectContext = CoreDataManager.shared.mainContext) {

        self.init(context: managedObjectContext)

        self.title = title
        self.identifier = identifier
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood.rawValue

    }

    convenience init?(entryRepresentation: EntryRepresentation,
        managedObjectContext: NSManagedObjectContext = CoreDataManager.shared.mainContext) {

        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }

        self.init(title: entryRepresentation.title,
            identifier: entryRepresentation.identifier,
            timestamp: entryRepresentation.timestamp,
            bodyText: entryRepresentation.bodyText,
            mood: mood
        )
    }

}
