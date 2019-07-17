//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/10/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    
    case 😡
    case 😐
    case 🤪
    
//    static var allMoods: [EntryMood] {
//        return [.😡, .😐, .🤪]
//    }
}

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood = .🤪, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
}
