//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chad Parker on 4/22/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😫
    case 😐
    case 😃
}

extension Entry {
    
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                     title: String,
                     mood: Mood,
                     bodyText: String,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let mood = Mood.init(rawValue: entryRepresentation.mood) ?? Mood.😐
        self.init(identifier: entryRepresentation.identifier,
                   title: entryRepresentation.title,
                   mood: mood,
                   bodyText: entryRepresentation.bodyText,
                   timestamp: entryRepresentation.timestamp,
                   context: context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard
            let bodyText = bodyText,
            let identifier = identifier,
            let mood = mood,
            let timestamp = timestamp,
            let title = title else { fatalError("something is nil") }
        
        return EntryRepresentation(bodyText: bodyText,
                            identifier: identifier,
                            mood: mood,
                            timestamp: timestamp,
                            title: title)
    }
}
