//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit
import CoreData

enum Mood: String, CaseIterable {
    case sad = "😔"
    case neutral = "😐"
    case happy = "😄"
}

extension Entry {
    
    //MARK: - Properties -
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let title = title, let bodyText = bodyText, let mood = mood, let timestamp = timestamp, let identifier = identifier else { return nil }
        
        return EntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood, timestamp: timestamp, title: title)
    }
    
    //MARK: - Methods -
    
    @discardableResult convenience init(title: String,
                                        bodyText: String?,
                                        timestamp: Date,
                                        identifier: String = UUID().uuidString,
                                        mood: String = "😐",
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        let title = entryRepresentation.title
        let bodyText = entryRepresentation.bodyText
        let mood = entryRepresentation.mood
        let timestamp = entryRepresentation.timestamp
        
        self.init(title: title,
                  bodyText: bodyText,
                  timestamp: timestamp,
                  identifier: identifier.uuidString,
                  mood: mood)
        
    }
    
}
