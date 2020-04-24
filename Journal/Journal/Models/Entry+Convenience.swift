//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Matthew Martindale on 4/21/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "😢"
    case neutral = "😐"
    case happy = "😄"
}

extension Entry {
    @discardableResult convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     mood: Mood,
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
