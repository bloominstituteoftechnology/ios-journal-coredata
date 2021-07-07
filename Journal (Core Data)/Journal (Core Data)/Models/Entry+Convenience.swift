//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😎
    case 😐
    case 😢
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timeStamp = timeStamp,
            let identifier = identifier, // Lightweight migration doesn't cover switching your identifier from type String to Type UUID. If the app crashes try switching all the data types in all modes to UUID and if that doesn't work, switch them all back to string.
            let mood = mood else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, identifier: identifier)
    }
    
    convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String = UUID().uuidString, mood: Mood, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
//        guard let identifier = entryRepresentation.identifier else { return } // Feel like there could be a problem in the future with not specifying this as the 'entryRepresentation`s' identifier.
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp,
                  identifier: entryRepresentation.identifier,
                  mood: mood, context: context)
    }
}
