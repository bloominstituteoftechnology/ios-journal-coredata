//
//  Entry+Convenience.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData
enum EntryMood: String, CaseIterable {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
}
extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     bodyText: String,
                     timeStamp: Date,
                     mood: String,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.mood = mood
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
}
