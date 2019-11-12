//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy, normal, sad
}

extension Entry {
    convenience init(name: String, description: String? = nil, time: Date, identification: String, mood: Mood = .normal, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = name
        self.timestamp = time
        self.bodyText = description
        self.mood = mood.rawValue
        self.identifier = identification
    }
}
