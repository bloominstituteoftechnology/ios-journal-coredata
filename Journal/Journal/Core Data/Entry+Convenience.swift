//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit
import CoreData

enum Mood: String, CaseIterable {
    case sad = "😔"
    case neutral = "😐"
    case happy = "😄"
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date, identifier: String = UUID().uuidString, mood: String = "😐", context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
}
