//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timeStamp = timeStamp,
            let mood = mood,
            let identifier = identifier else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, identifier: identifier)
    }
    
    convenience init(title: String,
                     bodyText: String,
                     timeStamp: Date,
                     identifier: String = UUID().uuidString,
                     mood: Mood = .neutral,
                     context: NSManagedObjectContext = CoreDataTask.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataTask.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp,
                  identifier: entryRepresentation.identifier,
                  mood: mood,
                  context: context)
    }
}
