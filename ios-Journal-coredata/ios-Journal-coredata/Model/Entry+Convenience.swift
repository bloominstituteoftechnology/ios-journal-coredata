//
//  Entry+Convenience.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/15/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😁
    case 😐
    case 🥺
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date.init(timeIntervalSinceNow: 0), identifier: String = "", mood: Mood, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
