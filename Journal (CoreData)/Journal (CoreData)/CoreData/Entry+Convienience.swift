//
//  Entry+Convienience.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

enum MoodLevel: String {
    case normal = "😐"
    case happy = "🙂"
    case sad = "☹️"
    
    static var allMoods: [MoodLevel] {
        return [.normal, .happy, .sad]
    }
}

enum EntryProperties: String {
    case title
    case bodyText
    case timestamp
    case identifier
    case mood
}
extension Entry {
    
    convenience init(title: String, bodyText: String?, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: String = "😐", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    convenience init?(entryRep: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    
        self.init(context: context)
        
        self.identifier = entryRep.identifier
        self.title = entryRep.title
        self.bodyText = entryRep.bodyText
        self.timestamp = entryRep.timestamp
        self.mood = entryRep.mood
    }
    
    var entryRepresentation: EntryRepresentation? {
        
        //guard let identifier = self.identifier else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
}
