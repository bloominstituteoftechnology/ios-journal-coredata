//
//  Entry + Convenience.swift
//  CoreDataJournal
//
//  Created by Joe Veverka on 5/18/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//
enum Mood: String, CaseIterable {
    case happy = "happy"
    case sad = "sad"
    case neutral = "neutral"
}

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timestamp: Date? = Date(),
                                        identifier: String = "",
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext){
        self.init(context : context)
        self.title = title
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
        
    }
}
