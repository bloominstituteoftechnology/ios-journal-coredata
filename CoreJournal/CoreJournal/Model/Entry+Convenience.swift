//
//  Entry+Convenience.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/28/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case angry = "🤬"
    case neutral = "🤨"
    case happy = "😁"
    
    static var allMoods: [Mood] {
        return [.angry, .neutral, .happy]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date? = Date(), identifier: String? = "", mood: Mood = .neutral, context: NSManagedObjectContext = CoreDataStack.shared
        .mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}

//
//var entryRep: EntryRep? {
//    guard let title = title,
//        let mood = mood else {
//            return nil
//    }
//    return EntryRep(identifier: identifier, title: title, bodyText: bodyText, mood: mood)
//}
//
//@discardableResult convenience init(title: String,
//                                    bodyText: String,
//                                    timestamp: Date,
//                                    mood: String,
//                                    identifier: UUID = UUID(),
//                                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
