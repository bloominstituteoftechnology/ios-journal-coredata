//
//  Entry+Convenience.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 🤩
    case 🧐
    case 😖
    
    static var allMoods: [Mood] {
        return[🤩, 🧐, 😖]
    }
}


extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date? = Date(), identifier: UUID = UUID(), mood: Mood = .🧐, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
    

}
