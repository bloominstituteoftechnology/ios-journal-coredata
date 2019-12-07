//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Joseph Rogers on 12/4/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation
import CoreData

enum MoodPriority: String {
    case 😔
    case 😐
    case 🙂
    
    static var allPriorities: [MoodPriority] {
        return [.😔, .😐, .🙂]
    }
}

extension Entry {
    convenience init(mood: MoodPriority = .😐,
                     title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     identifier: String = "",
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}


