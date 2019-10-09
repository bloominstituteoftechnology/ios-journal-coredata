//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Fabiola S on 10/2/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import Foundation
import CoreData

enum MoodControl: String, CaseIterable {
    case 😞
    case 😐
    case 🙂
    
}

extension Entry {
    convenience init(mood: String = MoodControl.😐.rawValue, title: String, bodyText: String?, timeStamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
    
     convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString),
            let bodyText = entryRepresentation.bodyText else { return nil }
        
        self.init(mood: entryRepresentation.mood, title: entryRepresentation.title, bodyText: bodyText, timeStamp: entryRepresentation.timeStamp, identifier: identifier, context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let bodyText = bodyText,
            let title = title,
            let mood = mood else { return nil }
        return EntryRepresentation(bodyText: bodyText, title: title, mood: mood, timeStamp: timeStamp ?? Date(), identifier: identifier?.uuidString ?? "")
    }
    
}
