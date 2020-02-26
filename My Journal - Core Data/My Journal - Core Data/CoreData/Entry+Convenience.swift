//
//  Entry+Convenience.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import CoreData

 extension Entry {
    
    var entryRepresentation : EntryRepresentation? {
        guard let timestamp = timestamp else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, identifier: identifier?.uuidString, timestamp: timestamp)
    }
    
     convenience init(title: String,
                      bodyText: String ,
                      timestamp: Date = Date(),
                      identifier : UUID = UUID(),
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                      mood: String)
     {
        self.init(context:context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.identifier = identifier
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard  let title = entryRepresentation.title,
                  let mood = entryRepresentation.mood,
                  let bodyText = entryRepresentation.bodyText,
                  let identifier = entryRepresentation.identifier else { return nil }
          
        
        self.init(title:title
                   ,bodyText:bodyText
                   ,timestamp:entryRepresentation.timestamp,
                    identifier:UUID(uuidString: identifier) ?? UUID(),
                   context:context,
                     mood:mood)
    }
    
    
    
    
}
