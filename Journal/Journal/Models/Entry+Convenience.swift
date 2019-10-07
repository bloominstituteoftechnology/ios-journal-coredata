//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case sad = "🙁"
    case okay = "😐"
    case happy = "🙂"
}

extension Entry {
    convenience init(mood: EntryMood = .okay, title: String, bodyText: String? = nil, timestamp: Date = Date(), identifier: String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
