//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/23/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 🙂
    case 😐
    case 🙁
}

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date, mood: String = "😐", identifier: UUID = UUID(), context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood
        self.identifier = identifier
    }
}
