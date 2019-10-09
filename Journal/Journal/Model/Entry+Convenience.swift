//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "0"
    case meh = "1"
    case happy = "2"
    
    var mood: String {
        switch self {
        case .sad:
            return "😞"
        case .meh:
            return "😐"
        case .happy:
            return "😁"
        }
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, identifier: String = "\(UUID())", timestamp: Date = Date(), mood: Mood = .meh, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
    

    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, identifier: entryRepresentation.identifier, timestamp: entryRepresentation.timestamp, mood: mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = self.title, let bodyText = self.bodyText, let timestamp = self.timestamp, let mood = self.mood, let identifier = self.identifier else { return nil }
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, mood: mood, identifier: identifier)
        
    }
    
    
}
