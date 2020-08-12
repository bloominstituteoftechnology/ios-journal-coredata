//
//  Entry+Convenience.swift
//  Journal
//
//  Created by ronald huston jr on 7/12/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😐
    case 😀
    case 😞
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = id,
        let title = title,
        let mood = mood,
        let timestamp = timestamp else { return nil }
        
        return EntryRepresentation(id: id, mood: mood, bodyText: bodyText!, title: title, timestamp: timestamp)
    }
    
    @discardableResult convenience init(id: String = "xyz",
                                        mood: Mood = .😐,
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.mood = mood.rawValue
        self.id = id
        self.title = title
        self.bodyText = bodyText
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(id: entryRepresentation.id,
                  mood: (Mood(rawValue: entryRepresentation.mood) ?? Mood(rawValue: "😖"))!,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  context: context)
    }
}
