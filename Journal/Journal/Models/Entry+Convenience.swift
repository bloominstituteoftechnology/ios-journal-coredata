//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Tobi Kuyoro on 27/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😀"
    case neutral = "😐"
    case sad = "😔"
}

extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date, identifier: String, mood: Mood = .neutral, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
        self.identifier = identifier
    }
}
