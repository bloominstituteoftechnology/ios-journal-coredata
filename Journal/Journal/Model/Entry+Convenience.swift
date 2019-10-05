//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "0"
    case meh = "1"
    case happy = "2"
    
    var mood: String {
        switch self {
        case .sad:
            return "😞"
        case .meh:
            return "😐"
        case .happy:
            return "😁"
        }
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, identifier: String = "entry", timestamp: Date = Date(), mood: Mood = .meh, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.mood = mood.rawValue
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
}
