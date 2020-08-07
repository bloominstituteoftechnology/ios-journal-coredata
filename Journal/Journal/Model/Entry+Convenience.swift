//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Cora Jacobson on 8/5/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    enum Mood: String, CaseIterable {
        case happy = "😀"
        case sad = "☹️"
        case neutral = "😐"
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(), title: String, bodyText: String, mood: Mood, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
    }
    
}
