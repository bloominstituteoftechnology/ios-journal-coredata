//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sean Hendrix on 11/5/18.
//  Copyright © 2018 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String, CaseIterable {
    case happy = "😃",
    sad = "😢",
    neutral = "😐"
}

extension Entry {
    convenience init(title: String,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     mood: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    
}
