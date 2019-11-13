//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy, normal, sad
}

extension Entry {
    convenience init(name: String, description: String? = nil, time: Date, identification: UUID = UUID(), mood: Mood = .normal, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = name
        self.timestamp = time
        self.bodyText = description
        self.mood = mood.rawValue
        self.identifier = identification
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
              let identifierString = entryRepresentation.identifier,
              let identifier = UUID(uuidString: identifierString) else {
              return nil
          }
        self.init(name: entryRepresentation.title, description: entryRepresentation.bodyText, time: entryRepresentation.timestamp, identification: identifier, mood: mood, context: context)
      }
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, identifier: identifier?.uuidString ?? "", timestamp: timestamp ?? Date())
    }
}
