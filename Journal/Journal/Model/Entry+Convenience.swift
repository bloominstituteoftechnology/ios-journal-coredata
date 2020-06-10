//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable{
    case 🥺
    case 😐
    case 😁
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation?{
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let identifier = identifier,
            let mood = mood else {return nil}
        
        return EntryRepresentation(title: title, timestamp: timestamp, mood: mood, identifier: identifier, bodyText: bodyText)
    }
    
    @discardableResult convenience init(identifier: String = "\(UUID())",
                                        timestamp: Date,
                                        title: String,
                                        bodyText: String,
                                        mood: Mood = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        self.identifier = identifier
        self.timestamp = timestamp
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
  
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil}
        
        self.init(identifier: entryRepresentation.identifier,
                  timestamp: entryRepresentation.timestamp,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  mood: mood,
                  context: context
                  )
    }
    
}

