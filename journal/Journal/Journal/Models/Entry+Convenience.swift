//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Ian French on 6/3/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import Foundation
import CoreData


enum Mood: String, CaseIterable {
    case sad =  "😢"
    case neutral = "😐"
    case happy = "😊"
}



extension Entry {
    
   // Computed property to get representation of a Task
    var entryRepresentation: EntryRepresentation? {
        guard let  mood = mood,
                 let  title = title,
                 let bodyText = bodyText,
                 let timestamp = timestamp
        else { return nil }
        
        let id = identifier ?? UUID().uuidString
        
        return EntryRepresentation(identifier: id,
                                  title: title,
                                  bodyText: bodyText,
                                  timestamp: timestamp,
                                  mood: mood)
    }
    
    
    
    
    @discardableResult convenience init(title: String, timestamp: Date = Date(), mood: Mood = .neutral, identifier: String, bodyText: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)  {
        
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.identifier = identifier
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood) else {
                return nil
        }
        
        self.init(title: entryRepresentation.title,
                  timestamp: entryRepresentation.timestamp,
                  mood: mood,
                  identifier: entryRepresentation.identifier,
                  bodyText: entryRepresentation.bodyText,
                  context: context)
    }
    
    
    
    
}


