//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Claudia Contreras on 4/22/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

enum MoodSelection: String, CaseIterable {
    case happy
    case neutral
    case sad
}

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String,
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        mood: MoodSelection = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // Set up the NSManagedObject portion of the Task object
        self.init(context: context)
        
        // Assign our unique values to the attributes we created in the data model file
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = MoodSelection(rawValue: entryRepresentation.mood) else {
                return nil
        }
        
        self.init(identifier: entryRepresentation.identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
        let mood = mood,
        let bodyText = bodyText,
        let timestamp = timestamp else { return nil }
        
        let id = identifier ?? UUID().uuidString
        
        return EntryRepresentation(identifier: id,
                                   title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   mood: mood)
    }
}
