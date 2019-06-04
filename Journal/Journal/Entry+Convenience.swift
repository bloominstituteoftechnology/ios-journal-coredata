//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jeremy Taylor on 6/3/19.
//  Copyright © 2019 Bytes Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "😀"
    
    static var allMoods: [Mood] {
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: Mood) {
        self.init(context: CoreDataStack.shared.mainContext)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
