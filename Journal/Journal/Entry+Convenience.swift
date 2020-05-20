//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kelson Hartle on 5/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import CoreData

    enum Mood: String, CaseIterable {
        case sad = "☹️"
        case ok = "😐"
        case happy = "😄"


    }

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
        let title = title,
        let mood = mood,
        let timeStamp = timeStamp,
        let bodyText = bodyText else { return nil }

        return EntryRepresentation(bodyText: bodyText,
                                   identifier: id,
                                   mood: mood,
                                   timeStamp: timeStamp,
                                   title: title)
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        
        self.init(context: context)
        self.bodyText = entryRepresentation.bodyText
        self.identifier = entryRepresentation.identifier
        self.mood = entryRepresentation.mood
        self.timeStamp = entryRepresentation.timeStamp
        self.title = entryRepresentation.title
        
    }
    

    @discardableResult convenience init(identifier: String = UUID().uuidString,
                                        bodyText: String,
                                        timeStamp: Date = Date(),
                                        title: String,
                                        mood: Mood = .ok,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.title = title
        self.mood = mood.rawValue
        
    }
}
