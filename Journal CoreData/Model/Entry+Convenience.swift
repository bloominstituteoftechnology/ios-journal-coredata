//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Andrew Ruiz on 9/16/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import Foundation
import CoreData

enum EmojiSelection: String, CaseIterable {
    case 😎
    case 🙏🏼
    case 💪🏽
}

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date, identifier: String, mood: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
}
