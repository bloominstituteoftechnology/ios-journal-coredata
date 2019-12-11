//
//  Entry+Convenience.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case low = "🙁"
    case normal = "😏"
    case great = "😁"
    
//    static var allMoods: [EntryMood] {
//        return [.low, .normal, .great]
//    }
}

extension Entry {
    convenience init(title: String,
                     mood: EntryMood = .normal,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: String? = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
