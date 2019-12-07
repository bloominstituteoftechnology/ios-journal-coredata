//
//  Entry+Conveinence.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😭
    case 😠
    case 🙂
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyTitle: String, timestamp: Date = Date.init(timeIntervalSinceNow: 0), identifier: String = "", mood: Mood, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyTitle = bodyTitle
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}

