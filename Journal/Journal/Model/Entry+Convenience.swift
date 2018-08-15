//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/13/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😀"
    
    static var allMoods: [Mood] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: String) {
        self.init(context: CoreDataStack.shared.mainContext)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init?(entryRep: EntryRepresentation) {
        
        self.init(title: entryRep.title, bodyText: entryRep.bodyText, timestamp: entryRep.timestamp, identifier: entryRep.identifier, mood: entryRep.mood)
    }
}
