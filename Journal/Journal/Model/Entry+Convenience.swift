//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😃"
    case neutral = "😐"
    case sad = "🙁"
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, identifier: String?, timeStamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
    }
}

