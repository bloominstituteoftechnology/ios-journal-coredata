//
//  Entry+Convenience.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, identifier: String = "\(UUID.self)", timestamp: Date = Date(), mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood
    }
}

//
//enum Mood: String, CaseIterable {
//    case 🙂
//    case 😐
//    case ☹️
//    
//    
//}
//
//
//extension Entry {
//    var mood: Mood {
//        get {
//            return Mood(rawValue: priority!) ?? .normal
//        } set {
//            priority = newValue.rawValue
//        }
//    }
//}
