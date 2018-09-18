//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jason Modisett on 9/17/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😟
    case 🤓
    case 🤠
    
    static var allMoods: [Mood] {
        return [.😟, .🤓, .🤠]
    }
}

extension Entry {
    
    convenience init(title: String, bodyText: String?, mood: Mood = .🤓, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
}
