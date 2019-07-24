//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😁
    case 😐
    case 🥺
    
    
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String? = nil, timeStamp: Date? = Date(), identifier: String? = UUID().uuidString, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = entryRepresentation.title
        self.bodyText = entryRepresentation.bodyText
        self.timeStamp = entryRepresentation.timeStamp
        self.identifier = entryRepresentation.identifier
        self.mood = entryRepresentation.mood
        
    }
    
    var entryRepresentation: EntryRepresentation {
        return EntryRepresentation(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
    }
    
    
    
}
