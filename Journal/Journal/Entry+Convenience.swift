//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case 🍕
    case 🍔
    case 🌮
    static var allMoods: [EntryMood] {
        return [.🍕, .🍔, .🌮]
    }
}

extension Entry {

    convenience init(title: String, timestamp: Date = Date(), identifier: UUID = UUID(), bodyText: String? = nil, mood: String = "🍕", context: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {

        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.identifier = identifier
        self.bodyText = bodyText
        self.mood = mood

    }


}
