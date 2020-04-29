//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Chad Parker on 4/22/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😫
    case 😐
    case 😃
}

extension Entry {
    
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                     title: String,
                     mood: Mood,
                     bodyText: String,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.mood = mood.rawValue
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}
