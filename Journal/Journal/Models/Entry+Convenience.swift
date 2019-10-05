//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bobby Keffury on 10/2/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

enum EntryPriority: Int16, CaseIterable {
    case 🙁 = 0
    case 😐 = 1
    case 🙂 = 2
    
    var name: String {
        switch self {
        case .🙁:
            return "🙁"
        case .😐:
            return "😐"
        case .🙂:
            return "🙂"
        
        }
    }
    
}

extension Entry {
    convenience init(mood: EntryPriority = .😐, title: String? = nil, timestamp: String? = nil, identifier: String? = nil, bodyText: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mood = mood.rawValue // not sure here
        self.title = title
        self.timestamp = timestamp
        self.identifier = identifier
        self.bodyText = bodyText
    }
    
}
