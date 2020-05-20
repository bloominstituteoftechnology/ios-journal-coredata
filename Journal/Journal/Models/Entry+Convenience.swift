//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😄"
    case sad = "☹️"
    case neutral = "😐"
}

extension Entry {
    
    
    @discardableResult convenience init(identifier: String = String(),
                                        title: String,
                                        bodyText: String,
                                        timeStamp: Date = Date(),
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
        
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = entryRepresentation.identifier else { return nil }
        //MARK: - HELP
        self.init(identifier: identifier, title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timeStamp: entryRepresentation.timeStamp, mood: Mood(rawValue: entryRepresentation.mood)!, context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood,
            let bodyText = bodyText,
            let timeStamp = timeStamp else { return nil }
        
        let id = identifier ?? UUID().uuidString
        
        return EntryRepresentation(title: title,
                                   bodyText: bodyText,
                                   mood: mood,
                                   identifier: id,
                                   timeStamp: timeStamp)
        
    }
}

