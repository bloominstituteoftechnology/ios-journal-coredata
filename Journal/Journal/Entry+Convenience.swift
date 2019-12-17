//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import CoreData
import Foundation

enum EntryMood: String {
    case happy = "😃"
    case netural = "😐"
    case sad = "🙁"
    
    static var allMoods: [EntryMood] {
        return [.happy, .netural, .sad]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String? = nil , timestamp: Date = Date(), identifier: String = UUID().uuidString ,mood: String = "😃", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodytext = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
}
 
