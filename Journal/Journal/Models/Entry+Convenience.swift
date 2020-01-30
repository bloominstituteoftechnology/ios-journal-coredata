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
    case happy = "😀"
    case neutral = "😐"
    case sad = "😔"
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timeStamp = timeStamp,
            let mood = mood,
            let identifier = identifier,
            let bodyText = bodyText else { return nil }
        
        return EntryRepresentation(title: title, timeStamp: timeStamp, mood: mood, identifier: identifier, bodyText: bodyText)
    }
    
    convenience init(title: String, bodyText: String, timeStamp: Date, identifier: String = UUID().uuidString, mood: Mood = .neutral, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        let identifier = entryRepresentation.identifier
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp,
                  identifier: identifier,
                  mood: mood,
                  context: context)
    }
}
