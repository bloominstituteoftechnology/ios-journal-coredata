//
//  Entry+Convenience.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

enum MoodTypes: String {
    case cranky = "☹️"
    case normal = "😐"
    case awesome = "😬"
    
    static var all: [MoodTypes] {
        return [.cranky, .normal, .awesome]
    }
}

extension Entry {
    
    convenience init(title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  mood: entryRepresentation.mood,
                  context: context)
        
        self.identifier = entryRepresentation.identifier
        self.timestamp = entryRepresentation.timestamp
    }
    
}
