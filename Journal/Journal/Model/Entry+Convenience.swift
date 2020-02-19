//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import Foundation
import CoreData

enum MoodStatus: String {
    case 😖
    case 😐
    case 😎
    
    static var allMoods: [MoodStatus] {
        return [😖, 😐, 😎]
    }
}

extension Entry {
    
    @discardableResult
    convenience init(title: String, bodytext: String, mood: String, timestamp: Date, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodytext = bodytext
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood
        //NS Date? do i need to initialize - not here 
        //Consider giving default values to the timestamp - How ?
    }
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = MoodStatus(rawValue: entryRepresentation.mood),
            let title = entryRepresentation.title,
            let bodytext = entryRepresentation.bodytext,
            let identifier = entryRepresentation.identifier,
            let timestamp = entryRepresentation.timestamp else { return nil }
        self.init(title: title,
                  bodytext: bodytext,
                  mood: mood.rawValue,
                  timestamp: timestamp,
                  identifier: identifier,
                  context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodytext = bodytext,
            let identifier = identifier,
            let mood = mood else { return nil }
            return EntryRepresentation(title: title, timestamp: timestamp,mood: mood, identifier: identifier, bodytext: bodytext)
    }
    
}

 
