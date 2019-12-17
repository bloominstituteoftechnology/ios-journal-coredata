//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Spencer Curtis on 8/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 👍
    case 🤙
    case 👎
    
    static var allMoods: [Mood] {
        return [.👍, .🤙, .👎]
    }
    
}

extension Entry {
    
    convenience init(title: String,
                     bodyText: String,
                     timestamp: Date = Date(),
                     mood: Mood = .👍,
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // This is just setting up the NSManagedObject part of the Entry class.
        self.init(context: context)
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
