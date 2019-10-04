//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

enum EntryPriority: String, CaseIterable {
    case 🙁
    case 😐
    case 🙂
}

extension Entry {
    convenience init(mood: EntryPriority = .😐, title: String? = nil, timestamp: String? = nil, identifier: String? = nil, bodyText: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood.rawValue
        self.title = title
        self.timestamp = timestamp
        self.identifier = identifier
        self.bodyText = bodyText
    }
    
}
