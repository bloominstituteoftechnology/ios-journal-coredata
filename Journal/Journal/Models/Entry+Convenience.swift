//
//  Entry.swift
//  Journal
//
//  Created by Jordan Christensen on 9/17/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 🤬
    case 😐
    case 😆
}

extension Entry {
    convenience init(title: String, bodyText: String, mood: EntryMood?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = Date()
        self.identifier = "Entry\(Int.random(in: 1...5000))"
        if let mood = mood {
            self.mood = mood.rawValue
        } else {
            self.mood = .😐
        }
    }
}
