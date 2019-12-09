//
//  Entry+Convenience.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case 🙁
    case 😏
    case 😁
    
    static var allMoods: [EntryMood] {
        return [.🙁, .😏, .😁]
    }
}

extension Entry {
    convenience init(title: String,
                     mood: EntryMood,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: String? = "",
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
