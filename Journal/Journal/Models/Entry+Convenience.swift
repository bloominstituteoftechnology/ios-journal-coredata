//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 💩 = "Shitty"
    case 😅 = "Ehhhhhhhhhh"
    case 🤩 = "WEEEWOOOO"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
        let bodyText = bodyText,
        let mood = mood
            else { return nil }
        return EntryRepresentation(bodyText: bodyText, identifier: identifier ?? UUID().uuidString, mood: mood, timeStamp: timeStamp ?? Date(), title: title)
    }
    
    
    @discardableResult convenience init(title: String,
                     timeStamp: Date = Date(),
                     identifier: String = "",
                     bodyText: String,
                     mood: Mood = .😅,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.bodyText = bodyText
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood) else {
            return nil
        }
        self.init(
            title: entryRepresentation.title,
            timeStamp: entryRepresentation.timeStamp,
            identifier: entryRepresentation.identifier,
            bodyText: entryRepresentation.bodyText,
            mood: mood)
        
        
        
        
        
    }
}
