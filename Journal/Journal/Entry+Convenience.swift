//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😀"
    case neutral = "😐"
    case sad = "☹️"
    
    static var Moods:[Mood]{
        return [.happy, .neutral, .sad]
    }
}


extension Entry{
    
    convenience init(title: String, bodytext: String? = nil, timestamp:Date = Date(), identifier: String = UUID().uuidString, mood: Mood = .neutral,  context:NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context:context)
        self.title = title
        self.bodytext = bodytext
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
        
    }
    
    convenience init?(entryRepresentation:EntryRepresentation, context:NSManagedObjectContext=CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else {return nil}
        guard let mood = Mood(rawValue: entryRepresentation.mood) else {return nil}
        
        self.init(title: entryRepresentation.title,
                  bodytext: entryRepresentation.bodytext,
                  timestamp: entryRepresentation.timestamp,
                  identifier: identifier.uuidString,
            mood: mood,
            context:context)
       
    }
}
