//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Craig Swanson on 12/4/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case ugh
    case meh
    case yea
    
    static var allMoods: [Mood] {
        return [.ugh, .meh, .yea]
    }
}

extension Entry {
    convenience init(title: String, mood: Mood = .meh, bodyText: String? = nil, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
