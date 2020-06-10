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
    case 😀
    case 😔
    case 😶
    
}

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        
        guard let mood = mood, let title = title else { return nil }
    
        let id = identifier ?? UUID().uuidString
        
        return EntryRepresentation(title: title,
                                   timestamp: timestamp!,
                                   bodyText: bodyText,
                                   identifier: id,
                                  mood: mood)
        
    }
    
       @discardableResult convenience init(title: String,
                                        timestamp: Date = Date.init(timeIntervalSinceNow: 0),
                                        bodyText: String? = nil,
                                        identifier: String = UUID().uuidString,
                                        mood: EntryMood = .😶,
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
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
                
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else {
                return nil
        }
        
        self.init(
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  identifier: entryRepresentation.identifier,
                  mood: mood,
                  context: context)
        
    }
    
}
