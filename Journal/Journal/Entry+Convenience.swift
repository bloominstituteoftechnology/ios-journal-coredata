//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 😶
    case 😔
    case 😀
}

extension Entry {
    @discardableResult convenience init(title: String,
                                        timestamp: Date,
                                        bodyText: String,
                                        identifier: String = UUID().uuidString,
                                        mood: EntryMood,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        //set up the NSManagaedObject portion of the task object
        self.init(context: context)
        
        //assign our unique values to the attributes we created in the data model file
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = identifier
        self.mood = mood.rawValue
        
            }
    @discardableResult convenience init?(EntryRepresentation: EntryRepresentation,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
                
        guard let mood = EntryMood(rawValue: entryRepresentation.mood), let identifier = EntryRepresentation.identifier else {
                return nil
        }
        
        self.init(identifier: entryRepresentation.identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  context: context)
        
    }
    
    // The way we convert our Task into a TaskRepresentation to be encoded and sent to a remote server as JSON
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title,
            let mood = mood, let bodyText = bodyText, let timestamp = timestamp else { return nil }
    
        let id = identifier ?? UUID().uuidString
        
        return EntryRepresentation(title: title,
                                   timestamp: timestamp,
                                   bodyText: bodyText,
                                   identifier: id,
                                  mood: mood)
        
    }
}
