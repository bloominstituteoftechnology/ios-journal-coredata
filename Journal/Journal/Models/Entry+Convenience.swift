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
        return EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp ?? Date(), identifier: identifier ?? UUID().uuidString, mood: mood)
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
        guard let title = entryRepresentation.title, let timestamp = entryRepresentation.timeStamp, let identifier = entryRepresentation.identifier, let bodyText = entryRepresentation.bodyText  else {
            return nil
        }
        self.init(
            title: title,
            timeStamp: timestamp,
            identifier: identifier,
            bodyText: bodyText,
            mood: .😅)
        
        
        
        
        
    }
}
