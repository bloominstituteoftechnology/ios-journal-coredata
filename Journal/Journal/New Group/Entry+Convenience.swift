//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Juan M Mariscal on 4/22/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy
    case sad
    case neutral
}

extension Entry {
    
    @discardableResult convenience init( identifier: UUID = UUID(),
                                         title: String,
                                         bodyText: String,
                                         timestamp: Date = Date(),
                                         mood: Mood,
                                         context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
}
