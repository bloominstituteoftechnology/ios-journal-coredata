//
//  Entry+Conveinence.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😭
    case 😠
    case 🙂
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        guard let bodyTitle = bodyTitle,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(bodyTitle: bodyTitle, identifier: identifier?.uuidString ?? UUID().uuidString, mood: mood, timestamp: timestamp!, title: title!)
    }
    
    convenience init(title: String, bodyTitle: String? = nil, timestamp: Date = Date.init(timeIntervalSinceNow: 0), identifier: UUID = UUID(), mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyTitle = bodyTitle
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else {
                return nil
        }
        
        self.init(title: entryRepresentation.title, bodyTitle: entryRepresentation.bodyTitle,
                  identifier: identifier,
                  mood: mood,
                  context: context)
    }
}

